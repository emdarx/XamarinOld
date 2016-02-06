-- Send Bot Plugin From Server v1.0
-- https://github.com/amirhmz/
-- https://telegram.me/AmirDark/
local function run(msg, matches)
  if matches[1] == "getplug" then
    local file = matches[2]
    if is_sudo(msg) then
      local receiver = get_receiver(msg)
      send_document(receiver, "./plugins/"..file..".lua", ok_cb, false)
    end
  end
end

return {
  patterns = {
  "^[!/](getplug) (.*)$",
  "^(getplug) (.*)$"
  },
  run = run
}
-- https://github.com/amirhmz/
-- https://telegram.me/AmirDark/
