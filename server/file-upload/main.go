// 2022-10-06 v3
package main

import (
	"fmt"
	"io"
	_"io/ioutil"
	"net/http"
	"os"
	"path/filepath"
	"time"
	"flag"
	"bufio"
	"os/exec"
	"syscall"
	"errors"
	"strings"
	"regexp"
	log "github.com/sirupsen/logrus"
)

const MAX_UPLOAD_SIZE = 10*1024 * 1024 // 10 * 1MB
const keyServerAddr = "serverAddr"

type MyConfig struct {
        //xfloat float64
	port string
	uploaddir string
	urlpath string
	command string
	maxsize int
}

var myParam = new(MyConfig)
var nonAlphanumericRegex = regexp.MustCompile(`[^a-zA-Z0-9.-_]+`)
var removeEOL = regexp.MustCompile(`;.*`)


///////////////////////////////////////////////////////////////////////////
func clearString(str string) string {
    return nonAlphanumericRegex.ReplaceAllString(str, "")
}

///////////////////////////////////////////////////////////////////////////
func execute(cmd string, hw http.ResponseWriter) (err error) {
        if cmd == "" {
                return errors.New("No command provided")
                }

        cmdArr := strings.Split(cmd, " ")
        name := cmdArr[0]

        args := []string{}
        if len(cmdArr) > 1 {
                args = cmdArr[1:]
                }

        command := exec.Command(name, args...)
        command.Env = os.Environ()

        stdout, err := command.StdoutPipe()
        if err != nil {
                log.Error("Failed creating command stdoutpipe: ", err)
                return err
                }
        defer stdout.Close()
        stdoutReader := bufio.NewReader(stdout)

        stderr, err := command.StderrPipe()
        if err != nil {
                log.Error("Failed creating command stderrpipe: ", err)
                return err
                }
        defer stderr.Close()
        stderrReader := bufio.NewReader(stderr)

        if err := command.Start(); err != nil {
                log.Error("Failed starting command: ", err)
                return err
                }

        go handleReader(stdoutReader,hw)
        go handleReader(stderrReader,hw)

        if err := command.Wait(); err != nil {
                if exiterr, ok := err.(*exec.ExitError); ok {
                        if status, ok := exiterr.Sys().(syscall.WaitStatus); ok {
                                log.Debug("Exit Status: ", status.ExitStatus())
                                return err
                                }
                        }
                return err
                }
        return nil
}


func handleReader(reader *bufio.Reader, hw http.ResponseWriter) error {
        for {
                str, err := reader.ReadString('\n')
                if len(str) == 0 && err != nil {
                        if err == io.EOF {
                                break
                                }
                        return err
                        }

                fmt.Print(str)
		fmt.Fprintf(hw, str)

                if err != nil {
                        if err == io.EOF {
                                break
                                }
                        return err
                        }
                }

        return nil
}


//////////////////////////////////////////////////////////////////////////

// Progress is used to track the progress of a file upload.
// It implements the io.Writer interface so it can be passed
// to an io.TeeReader()
type Progress struct {
	TotalSize int64
	BytesRead int64
}

// Write is used to satisfy the io.Writer interface.
// Instead of writing somewhere, it simply aggregates
// the total bytes on each read
func (pr *Progress) Write(p []byte) (n int, err error) {
	n, err = len(p), nil
	pr.BytesRead += int64(n)
	pr.Print()
	return
}

// Print displays the current progress of the file upload
func (pr *Progress) Print() {
	if pr.BytesRead == pr.TotalSize {
		fmt.Println("DONE!")
		return
	}

	fmt.Printf("File upload in progress: %d\n", pr.BytesRead)
}

func IndexHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Add("Content-Type", "text/html")
	fmt.Printf("url:%s\n", r.URL.Path)
	http.ServeFile(w, r, "index.html")
}

func AboutHandler(w http.ResponseWriter, r *http.Request) {
	// https://www.digitalocean.com/community/tutorials/how-to-make-an-http-server-in-go
	// This only for testing routing ...
	//ctx := r.Context()
	fmt.Printf("About url:%s\n", r.URL.Path)
	//hasFirst := r.URL.Query().Has("first")
	//first := r.URL.Query().Get("first")
	// body, err := ioutil.ReadAll(r.Body)
	w.Header().Add("Content-Type", "text/html")
	http.ServeFile(w, r, "ok.html")
}

func uploadHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != "POST" {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	// 32 MB is the default used by FormFile
	if err := r.ParseMultipartForm(32 << 20); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}


	// filenames uploaded
	var filesstr = ""
	var diskfilesstr = ""


//-----------------------------------------

	// get a reference to the fileHeaders
	//sala := r.MultipartForm.FormName["sala"]
	//sala := r.PostFormValue("sala") 
	sala := r.MultipartForm.Value["sala"]
	fmt.Printf("Sala : %s\n", sala)
	files := r.MultipartForm.File["file"]
	filecnt := 0
	debug := "0"
	//fmt.Sprintf(
	debugstr := fmt.Sprintf("%s",r.MultipartForm.Value["debug"])
	if debugstr == "1"   { debug = "1" }
	for _, fileHeader := range files {
		// remove special chars from filename
		filename := strings.ToLower(fileHeader.Filename)
		filename = clearString(filename)
		fmt.Printf("File : %s - %s\n", fileHeader.Filename,filename)
		fmt.Printf("Sala : %s\n", sala)
		if fileHeader.Size > MAX_UPLOAD_SIZE {
			http.Error(w, fmt.Sprintf("The uploaded file is too big: %s. Please use an file less than 10MB in size", fileHeader.Filename), http.StatusBadRequest)
			return
		}

		file, err := fileHeader.Open()
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		defer file.Close()

		buff := make([]byte, 512)
		_, err = file.Read(buff)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		ok := 0
		filetype := http.DetectContentType(buff)
		// filetype include some extra after ;
		// ex. text/plain; charset=utf-8
		filetype = removeEOL.ReplaceAllString(filetype, "")
		fmt.Printf("Type : %s\n", filetype)
		switch filetype {
			case "image/jpeg": ok=1
			case "image/png": ok=1
			case "text/plain": ok=1
			case "text/xml": ok=1
			case "text/json": ok=1
			case "application/octet-stream": ok=1
			case "application/zip": ok=1
			default: ok=0
			}

		if ok!= 1  {
			http.Error(w, "The provided file format is not allowed. Please upload a txt, xml, csv, lst", http.StatusBadRequest)
			return
		}

		//fileext := filepath.Ext(fileHeader.Filename)
		fileext := filepath.Ext(filename)
		if fileext == ".jpg"  { ok = 1 }
		if fileext == ".png"   { ok = 1 }
		if fileext == ".txt"   { ok = 1 }
		if fileext == ".csv"   { ok = 1 }
		if fileext == ".lst"   { ok = 1 }
		if fileext == ".xml"   { ok = 1 }
		if fileext == ".zip"   { ok = 1 }
		fmt.Printf("Ext : %s %d\n", fileext,ok)

		if (ok != 1 ) {
			http.Error(w, "The provided file format is not allowed. Please upload a txt, xml, csv, lst", http.StatusBadRequest)
			return
		}

		_, err = file.Seek(0, io.SeekStart)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		err = os.MkdirAll("./uploads", os.ModePerm)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		filesstr = filesstr + " " + filename
		//filepath := fmt.Sprintf("./uploads/%d.%s", time.Now().UnixNano(), fileHeader.Filename)
		diskfilename := fmt.Sprintf("%d.%s", time.Now().UnixNano(), filename)
		diskfilesstr = diskfilesstr + " " + diskfilename
		//filepath := fmt.Sprintf("./uploads/%d.%s", time.Now().UnixNano(), filename)
		filepath := fmt.Sprintf("%s/%s", myParam.uploaddir,diskfilename)
		fmt.Printf("Kirj : %s\n", filepath)
		// filepath.Ext(fileHeader.Filename)
		f, err := os.Create(filepath)  // filepath.Ext(fileHeader.Filename)))
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		defer f.Close()

		pr := &Progress{
			TotalSize: fileHeader.Size,
		}

		_, err = io.Copy(f, io.TeeReader(file, pr))
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		filecnt++
		}
	}

	//w.Header().Add("Content-Type", "text/html")
	//fmt.Fprintf(w, "Upload successful")

	//w.Header().Add("Content-Type", "text/html")
	//http.ServeFile(w, r, "ok.html")

	w.Header().Add("Content-Type", "text/plain")
	fmt.Fprintf(w, "Uploaded OK\n")
	//fmt.Fprintf(w, "Files (%d):%s\n",filecnt,filesstr)
	if debug != "0" { fmt.Fprintf(w, "Files (%d):%s\n",filecnt,diskfilesstr) }
	//execute("ping -c 2 www.google.com",w)
	cmdstr := myParam.command + " -d " + debug + " -p " + myParam.uploaddir + " " + diskfilesstr
	execute(cmdstr,w)
}

func main() {
	//myParam := new(MyConfig)
	//port := flag.String("p", "14500", "port to listen on")
	flag.StringVar(&myParam.port,"p", "14500", "port to listen on")
	flag.StringVar(&myParam.uploaddir,"d", "uploads", "upload dir")
	//flag.StringVar(&myParam.urlpath,"u", "/variantcheck/upload", "upload url")
	flag.StringVar(&myParam.urlpath,"u", "/variantcheck", "root urlpath")
	flag.StringVar(&myParam.command,"c", "ping -c 2 8.8.8.8", "execute command after upload")
	flag.IntVar(&myParam.maxsize,"x", MAX_UPLOAD_SIZE, "max filesize")
	flag.Parse()
	address := "127.0.0.1:" + myParam.port

	fmt.Printf("- listening on %s \n",myParam.port)
	fmt.Printf("- root urlpath %s \n",myParam.urlpath)
	fmt.Printf("- upload dir %s \n",myParam.uploaddir)
	fmt.Printf("- command %s \n",myParam.command)
	fmt.Printf("- maxsize uploadfile %d \n",myParam.maxsize)

	mux := http.NewServeMux()
	mux.HandleFunc("/", IndexHandler)   // default if next not match
	mux.HandleFunc(myParam.urlpath + "/about/", AboutHandler)
	addOn :=  http.StripPrefix(myParam.urlpath +"/addon/",http.FileServer(http.Dir("./lib")))
	//http.Handle("/dl/", http.StripPrefix("/dl", http.FileServer(http.Dir("/home/bob/Downloads")))
	mux.Handle(myParam.urlpath +"/addon/", addOn)
	mux.HandleFunc(myParam.urlpath + "/upload", uploadHandler)

	//if err := http.ListenAndServe(":14500", mux); err != nil {
	if err := http.ListenAndServe(address, mux); err != nil {
		log.Fatal(err)
	}
}
