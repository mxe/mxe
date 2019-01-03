local lpeg = require 'lpeg'
assert(((lpeg.R('AZ'))^1):match("TEXT") == 5)

local http = require "socket.http"
assert(http.request("http://example.org/"):match('Example'))

local ll = require 'llthreads2'
local thread = ll.new("return 123")
thread:start()
local ok, result = thread:join()
assert(ok)
assert(result == 123)

local rapidjson = require 'rapidjson'
assert(rapidjson.encode(123) == '123')
assert(rapidjson.decode('["xyz"]')[1] == "xyz")
