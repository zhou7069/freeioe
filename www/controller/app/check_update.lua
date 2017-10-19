local skynet = require 'skynet'
local dc = require 'skynet.datacenter'

return {
	get = function(self)
		local get = ngx.req.get_uri_args()
		local inst = get.inst
		local app = dc.get('APPS', inst)
		assert(app and app.name==get.app)
		local beta = dc.get('CLOUD', 'USING_BETA')
		local ver, bver = skynet.call("UPGRADER", "lua", "pkg_check_update", app.name, app.version, beta)
		local ret = {version = ver}
		if bver then
			ret.beta = bver
		end
		lwf.json(self, ret)
	end,
}