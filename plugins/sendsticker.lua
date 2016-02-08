do

function run(msg, matches)
send_document(get_receiver(msg), "./stickers/logo.webp", ok_cb, false)
end

return {
patterns = {
"^[!/]([Xx]amarin)",
"^([Xx]amarin)"

},
run = run
}

end
