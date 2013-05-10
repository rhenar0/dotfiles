#colors
@colors = []

(2..7).each do |i|

  block = "\\[\e[0;3" + i.to_s + "m\\]"
  #block2 = "\\[\e[1;3" + i.to_s + "m\\]"
  @colors << block #<< block2

end


def random_color(char)
  @colors[rand(5)] + char
end

prompt = ''


Time.now.strftime('%H:%M:%S').split('').each do |char|
  prompt = prompt + random_color(char)
end

prompt = prompt + ' :: '

ARGV.each do |arg|
  arg.split('').each do |char|
    prompt = prompt + random_color(char)
  end
end

puts prompt
