do

function run(msg, matches)
  return "سلام " .. matches[1]
end

return {
    patterns = {
    "^سلام کن به (.*)$"
  }, 
  run = run 
}

end
