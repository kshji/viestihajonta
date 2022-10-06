# Viestihajonta tarkasataja online palvelin - Variant checking online server

## Pre install
You need Go-language to build binary server.

You can copy precompiled binary version from **release** directory.

Server run in some free port. Use frontend proxy to redirect to the **variantcheck** server.
Currently this server not support SSL. Frontend proxy is better place to make generic SSL support for the
public server.

This server is microserver which only support orienteering cource variant checking.

##
