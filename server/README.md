# Viestihajonta tarkastaja -online palvelin - Variant checking online server
This is done for checking orienteering forking system.
This server check legs (control to control pairs) in the relay and individual competition using forking.

Check: Run the same overall course.

## Pre install
You need Go-language to build binary server.

You can copy precompiled binary version from **release** directory.

Server run using some free port. Use frontend proxy to redirect to the **variantcheck** server.
Currently this server not support SSL. Frontend proxy is better place to make generic SSL support for the
public server.

This server is microserver which only support orienteering cource variant checking.

## Start server

```sh
./server.sh
```

## Stop server

```sh
./server.sh -s
```

## Sourcecode
[Server subsystem](https://github.com/kshji/viestihajonta/tree/main/server). You need to install full system, server use CLI-version. 
Server is only frontsystem for CLI.

## Discussion/Feedback/... Palaute
[Discussion](https://github.com/kshji/viestihajonta/discussions) - [Keskustelupalsta](https://github.com/kshji/viestihajonta/discussions)


## LICENSE file-upload
[Server based on Freshman upload server code](https://github.com/Freshman-tech/file-upload).
Read [LICENCE](file-upload/LICENCE).
This server is also under [Unlicensed Free Software](https://unlicense.org/)


