--- Verify if `sudo` is already authenticated
--- @return boolean
local function sudo_already()
	local status = Command("sudo"):args({ "--validate", "--non-interactive" }):status()
	assert(status, "Failed to run `sudo --validate --non-interactive`")
	return status.success
end

--- Run a program with `sudo` privilege
--- @param program string
--- @param args table
--- @return Output|nil output
--- @return integer|nil err
---  nil: no error
---  1: sudo failed
local function run_with_sudo(program, args)
	local cmd = Command("sudo"):args { program, table.unpack(args) }
	if sudo_already() then
		return cmd:output()
	end

	local permit = ya.hide()
	print(string.format("Sudo password required to run: `%s %s`", program, table.concat(args)))
	local output = cmd:output()
	permit:drop()

	if output.status.success or sudo_already() then
		return output
	end
	return nil, 1
end

return {
	entry = function()
		local output = run_with_sudo("ls", { "-l" })
		if not output then
			return ya.err("Failed to run `sudo ls -l`")
		end

		ya.err("stdout", output.stdout)
		ya.err("status.code", output.status.code)
	end,
}
