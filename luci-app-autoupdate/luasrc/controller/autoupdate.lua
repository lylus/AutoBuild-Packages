module("luci.controller.autoupdate",package.seeall)

function index()
	if not nixio.fs.access("/etc/config/autoupdate") then
		return
	end
	entry({"admin", "system", "autoupdate"}, alias("admin", "system", "autoupdate", "main"),_("AutoUpdate"), 99).dependent = true
	entry({"admin", "system", "autoupdate", "main"}, cbi("autoupdate/main"),_("Scheduled Upgrade"), 10).leaf = true
	entry({"admin", "system", "autoupdate", "manual"}, cbi("autoupdate/manual"),_("Manually Upgrade"), 20).leaf = true
	entry({"admin", "system", "autoupdate", "log"}, form("autoupdate/log"),_("Upgrade Log"), 30).leaf = true

	entry({"admin", "system", "autoupdate", "print_log"}, call("print_log")).leaf = true
end

function print_log()
	local logfile = luci.sys.exec("autoupdate --env Log_File")
	luci.http.write(luci.sys.exec("tail " .. logfile .. " -n 100 2> /dev/null"))
end