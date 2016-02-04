--- Spammer Plugin For Xamarin v1.0
--- https://github.com/amirhmz
--- https://telegram.me/AmirDark

local function run(msg, matches)

  local receiver = get_receiver(msg)
    if matches[1] == "spam" and is_admin(msg) then
    local num = matches[2]
     local text = matches[3]
        for i=1,num do
            send_large_msg(receiver, text)
        end
  end
end
 
return {
  patterns = {
  "^[!/](spam) (%d+) (.*)$",
  "^(spam) (%d+) (.*)$",
  },
  run = run,
}

--- https://github.com/amirhmz
--- https://telegram.me/AmirDark
