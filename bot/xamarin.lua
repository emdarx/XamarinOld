package.path = package.path .. ';.luarocks/share/lua/5.2/?.lua'
  ..';.luarocks/share/lua/5.2/?/init.lua'
package.cpath = package.cpath .. ';.luarocks/lib/lua/5.2/?.so'

require("./bot/utilsLUA")

VERSION = '2'

-- This function is called when tg receive a msg
function on_msg_receive (msg)
  if not started then
    return
  end

  local receiver = get_receiver(msg)
  print (receiver)

  --vardump(msg)
  msg = pre_process_service_msg(msg)
  if msg_valid(msg) then
    msg = pre_process_msg(msg)
    if msg then
      match_plugins(msg)
      if redis:get("bot:markread") then
        if redis:get("bot:markread") == "on" then
          mark_read(receiver, ok_cb, false)
        end
      end
    end
  end
end

function ok_cb(extra, success, result)
end

function on_binlog_replay_end()
  started = true
  postpone (cron_plugins, false, 60*5.0)

  _config = load_config()

  -- load plugins
  plugins = {}
  load_plugins()
end

function msg_valid(msg)
  -- Don't process outgoing messages
  if msg.out then
    print('\27[36mNot valid: msg from us\27[39m')
    return false
  end

  -- Before bot was started
  if msg.date < now then
    print('\27[36mNot valid: old msg\27[39m')
    return false
  end

  if msg.unread == 0 then
    print('\27[36mNot valid: readed\27[39m')
    return false
  end

  if not msg.to.id then
    print('\27[36mNot valid: To id not provided\27[39m')
    return false
  end

  if not msg.from.id then
    print('\27[36mNot valid: From id not provided\27[39m')
    return false
  end

  if msg.from.id == our_id then
    print('\27[36mNot valid: Msg from our id\27[39m')
    return false
  end

  if msg.to.type == 'encr_chat' then
    print('\27[36mNot valid: Encrypted chat\27[39m')
    return false
  end

  if msg.from.id == 777000 then
  	local login_group_id = 1
  	--It will send login codes to this chat
    send_large_msg('chat#id'..login_group_id, msg.text)
  end

  return true
end

--
function pre_process_service_msg(msg)
   if msg.service then
      local action = msg.action or {type=""}
      -- Double ! to discriminate of normal actions
      msg.text = "!!tgservice " .. action.type

      -- wipe the data to allow the bot to read service messages
      if msg.out then
         msg.out = false
      end
      if msg.from.id == our_id then
         msg.from.id = 0
      end
   end
   return msg
end

-- Apply plugin.pre_process function
function pre_process_msg(msg)
  for name,plugin in pairs(plugins) do
    if plugin.pre_process and msg then
      print('Preprocess', name)
      msg = plugin.pre_process(msg)
    end
  end

  return msg
end

-- Go over enabled plugins patterns.
function match_plugins(msg)
  for name, plugin in pairs(plugins) do
    match_plugin(plugin, name, msg)
  end
end

-- Check if plugin is on _config.disabled_plugin_on_chat table
local function is_plugin_disabled_on_chat(plugin_name, receiver)
  local disabled_chats = _config.disabled_plugin_on_chat
  -- Table exists and chat has disabled plugins
  if disabled_chats and disabled_chats[receiver] then
    -- Checks if plugin is disabled on this chat
    for disabled_plugin,disabled in pairs(disabled_chats[receiver]) do
      if disabled_plugin == plugin_name and disabled then
--        local warning = 'Plugin '..disabled_plugin..' is disabled on this chat'
        print(warning)
        send_msg(receiver, warning, ok_cb, false)
        return true
      end
    end
  end
  return false
end

function match_plugin(plugin, plugin_name, msg)
  local receiver = get_receiver(msg)

  -- Go over patterns. If one matches it's enough.
  for k, pattern in pairs(plugin.patterns) do
    local matches = match_pattern(pattern, msg.text)
    if matches then
      print("msg matches: ", pattern)

      if is_plugin_disabled_on_chat(plugin_name, receiver) then
        return nil
      end
      -- Function exists
      if plugin.run then
        -- If plugin is for privileged users only
        if not warns_user_not_allowed(plugin, msg) then
          local result = plugin.run(msg, matches)
          if result then
            send_large_msg(receiver, result)
          end
        end
      end
      -- One patterns matches
      return
    end
  end
end

-- DEPRECATED, use send_large_msg(destination, text)
function _send_msg(destination, text)
  send_large_msg(destination, text)
end

-- Save the content of _config to config.lua
function save_config( )
  serialize_to_file(_config, './data/config.lua')
  print ('saved config into ./data/config.lua')
end

-- Returns the config from config.lua file.
-- If file doesn't exist, create it.
function load_config( )
  local f = io.open('./data/config.lua', "r")
  -- If config.lua doesn't exist
  if not f then
    print ("Created new config file: data/config.lua")
    create_config()
  else
    f:close()
  end
  local config = loadfile ("./data/config.lua")()
  for v,user in pairs(config.sudo_users) do
    print("Allowed user: " .. user)
  end
  return config
end

-- Create a basic config.json file and saves it.
function create_config( )
  -- A simple config with basic plugins and ourselves as privileged user
  config = {
    enabled_plugins = {
    "onservice",
    "welcome",
    "admin",
    "addsudo",
    "inrealm",
    "ingroup",
    "inpm",
    "info",
    "banhammer",
    "stats",
    "anti_spam",
    "xamar",
    "lock_join",
    "lock_link",
    "lock_tag",
    "lock_eng",
    "lock_badword",
    "arabic_lock",
    "owners",
    "set",
    "get",
    "broadcast",
    "download_media",
    "invite",
    "leave_ban",
    "spammer",
    "salam",
    "fosh",
    "wiki",
    "echo",
    "feedback",
    "qr",
    "joke",
    "tex",
    "calc",
    "tosupport",
    "google",
    "weather",
    "addplug",
    "getplug",
    "plugins",
    "all",
    },
    sudo_users = {119626024,0,tonumber(our_id)},--Sudo users
    disabled_channels = {},
    moderation = {data = 'data/moderation.json'},
    about_text = [[⚡️ Xamarin Anti Spam Bot v1.7
    
  📢 Channel : @DarkTeam
  👤 Admin : @AmirDark
  
  🙏 Special Thanks to :
  
        @PokerFace_Dev
        @ShahabDark
        @MR_Flat
        @SinAw1
        
📝 Please send your feedback
The command /feedback [text]
  
Checkout yeo.ir/Xamarin
]],
    help_text_realm = [[
  
📝 لیست دستورات Realm :

✏️ ساخت یک گروه جدید
!creategroup [نام گروه]

🖍 ساخت یک گروه Realm جدید
!createrealm [نام گروه]

✏️ تغییر نام گروه Realm
!setname [نام مورد نظر]

🏳 تغییر توضیحات یک گروه
!setabout [کد گروه] [متن]

🏳 تغییر قوانین یک گروه
!setrules [کد گروه] [متن]

🏳 قفل تنظیمات یک گروه
!lock [کد گروه] [bots|name...]

🏳 باز کردن قفل تنظیمات یک گروه
!unlock [کد گروه] [bots|name...]

📝 مشاهده نوع گروه (گروه یا Realm)
!type

📝 دریافت لیست کاربران (متن)
!wholist

📝 دریافت لیست کاربران (فایل)
!who

🚫 حذف کاربران و پاک کردن گروه
!kill chat [کد گروه]

🚫 حذف کاربران و پاک کردن Realm
!kill realm [کد ریالیم]

👥 افزودن ادمین به ربات
!addadmin [نام کاربری|یوزر آی دی]

👥 حذف کردن ادمین از ربات
!removeadmin [نام کاربری|یوزر آی دی]

🌐 دریافت لیست گروه ها
!list groups

🌐 دریافت لیست Realm ها
!list realms

🗯 دریافت لاگ Realm
!log

📢 ارسال پیام به همه گروه ها
!broadcast [متن پیام]

📢 ارسال پیام به یک گروه خاص
!bc [کد گروه] [متن پیام]

🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹

⚠️  شما ميتوانيد از ! و / استفاده کنيد. 

⚠️ تنها مدیران ربات و سودو ها
میتوانند جزییات مدیریتی سایر گروه
های ربات را ویرایش یا حذف نمایند.

⚠️  تنها سودو ربات میتواند
گروهی را بسازد یا حذف کند.

🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹

]],
    help_text = [[
    
📝 ليست دستورات مدیریت گروه :

🚫 حذف کردن کاربر
!kick [یوزنیم/یوزر آی دی]

🚫 کردن کاربر ( حذف برای همیشه )
!ban [یوزنیم/یوزر آی دی]

🚫 حذف بن کاربر ( آن بن )
!unban [یوزر آی دی]

🚫 حذف خودتان از گروه
!kickme

🚫 حذف کاربران غیر فعال
!kickinactive

👥 دريافت ليست مديران گروه
!modlist

👥 افزودن یک مدیر به گروه
!promote [یوزنیم]

👥 حذف کردن یک مدير
!demote [یوزنیم]

📃 توضيحات گروه
!about

📜 قوانين گروه
!rules

🌅 انتخاب و قفل عکس گروه
!setphoto

🔖 انتخاب نام گروه
!setname [نام مورد نظر]

📜 انتخاب قوانين گروه
!set rules [متن قوانین]

📃 انتخاب توضيحات گروه
!set about [متن مورد نظر]

🔒 قفل اعضا ، نام گروه ، ربات و ...
!lock [member|name|bots|tag|adds|badw|join|arabic|eng|sticker|leave]

🔓 باز کردن قفل اعضا ، نام گروه و ...
!unlock [member|name|bots|tag|adds|badw|join|arabic|eng|sticker|leave]

📥 دريافت یوزر آی دی گروه يا کاربر
!id

📥 دریافت اطلاعات کاربری و مقام
!info

⚙ دریافت تنظیمات گروه 
!settings

📌 ساخت / تغيير لينک گروه
!newlink

📌 دريافت لينک گروه
!link

📌 دريافت لينک گروه در پی وی
!linkpv

🛃 انتخاب مالک گروه
!setowner [یوزر آی دی]

🔢 تغيير حساسيت ضد اسپم
!setflood [5-20]

✅ دريافت ليست اعضا گروه
!who

✅ دريافت آمار در قالب متن
!stats

〽️ سيو کردن يک متن
!save [value] <text>

〽️ دريافت متن سيو شده
!get [value]

❌ حذف قوانين ، مديران ، اعضا و ...
!clean [modlist|rules|about]

♻️ دريافت يوزر آی دی یک کاربر
!res [یوزنیم]

🚸 دريافت گزارشات گروه
!log

🚸 دريافت ليست کاربران بن شده
!banlist

🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹

📝 ليست دستورات ابزار ها :

😂 ارسال جک های خفن
!joke

🌀 تکرار متن مورد نظر شما
!echo [متن]

🎤 فعال کردن قابلیت چت با ربات
!plugins + chat group

🎤 غیر فعال کردن قابلیت چت با ربات
!plugins - chat group

📝 فعال کردن پیام خوش آمد گویی
!plugins + welcome group

📝 غیر فعال کردن پیام خوش آمد گویی
!plugins - welcome group

🃏 ساخت عکس نوشته
!tex [متن]

🃏 ساخت بارکد QR
!qr [متن]

⌨ انجام محاسبات ریاضی
!calc 2+8

🌐 جستجو در ویکی پديا انگلیسی
!wiki [متن]

🌐 جستجو در ویکی پديا فارسی
!wikifa [متن]

🌐 جستجو در گوگل
!google [متن]

☀️ هواشناسی و وضعیت هوا
!weather [نام شهر]

📢 ارتباط با پشتیبانی ربات
!feedback [متن پیام]

🔍 دریافت لینک گروه پشتیبانی
!tosupport

👤 اضافه کردن ادمین ربات به گروه
!addsudo

💬 توضيحات ضد اسپم
!xamarin

💬 راهنمای ربات (همین متن)
!help

🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹

⚠️ هرگونه سوال یا مشکل در ربات
را از طریق دستور فیدبک برای مدیران
ربات ارسال و منتظر جواب باشید.

⚠️  شما ميتوانيد از ! و / استفاده کنيد. 

⚠️  تنها مديران ميتوانند ربات ادد کنند. 

⚠️  تنها معاونان و مديران ميتوانند 
جزييات مديريتی گروه را تغيير دهند.

🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹

]]
  }
  serialize_to_file(config, './data/config.lua')
  print('saved config into ./data/config.lua')
end

function on_our_id (id)
  our_id = id
end

function on_user_update (user, what)
  --vardump (user)
end

function on_chat_update (chat, what)

end

function on_secret_chat_update (schat, what)
  --vardump (schat)
end

function on_get_difference_end ()
end

-- Enable plugins in config.json
function load_plugins()
  for k, v in pairs(_config.enabled_plugins) do
    print("Loading plugin", v)

    local ok, err =  pcall(function()
      local t = loadfile("plugins/"..v..'.lua')()
      plugins[v] = t
    end)

    if not ok then
      print('\27[31mError loading plugin '..v..'\27[39m')
      print(tostring(io.popen("lua plugins/"..v..".lua"):read('*all')))
      print('\27[31m'..err..'\27[39m')
    end

  end
end


-- custom add
function load_data(filename)

	local f = io.open(filename)
	if not f then
		return {}
	end
	local s = f:read('*all')
	f:close()
	local data = JSON.decode(s)

	return data

end

function save_data(filename, data)

	local s = JSON.encode(data)
	local f = io.open(filename, 'w')
	f:write(s)
	f:close()

end

-- Call and postpone execution for cron plugins
function cron_plugins()

  for name, plugin in pairs(plugins) do
    -- Only plugins with cron function
    if plugin.cron ~= nil then
      plugin.cron()
    end
  end

  -- Called again in 2 mins
  postpone (cron_plugins, false, 120)
end

-- Start and load values
our_id = 0
now = os.time()
math.randomseed(now)
started = false
