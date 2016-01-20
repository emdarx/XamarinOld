do

function run(msg, matches)
  return "ناموسا گاییدمت " .. matches[1]
end

return {
    patterns = {
    "^فحش بده به (.*)$"
  }, 
  run = run 
}

end
