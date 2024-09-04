# frozen_string_literal: true

# Some modificated code from video https://www.youtube.com/watch?v=Eu9HIgSSx7Q

require 'watir'

start_script = Time.now

browser = Watir::Browser.new
browser.goto('https://prom.ua/ua/search?search_term=Nikon%20D3100')

products = []

loop do
  parsed_products = browser.divs(class: 'JicYY')

  parsed_products.each do |pp|
    if pp.span(class: 'yzKb6').present?
      products << { name: pp.span(class: '_3Trjq htldP _7NHpZ h97_n').text, price: pp.span(class: 'yzKb6').text.tr(' ', '').to_i }
    end
  end

  break unless browser.a(data_qaid: 'next_page').present?

  browser.a(data_qaid: 'next_page').click
  sleep 2
end

browser.close

filtered_products = products.select do |prod|
  prod[:name].match(/\bNikon D3100\b/i)
end

products_sum = 0
products.each { |pp| products_sum += pp[:price] }

filtered_products_sum = 0
filtered_products.each { |fp| filtered_products_sum += fp[:price] }

end_script = Time.now
time_wasted = end_script - start_script

puts 'Count:'
puts "  Parsed products: #{products.count}"
puts "  Filtered products: #{filtered_products.count}"
puts 'Sum price:'
puts "  Parsed products: #{products_sum}"
puts "  Filtered products: #{filtered_products_sum}"
puts 'Avg price:'
puts "  Parsed products: #{products_sum / products.count}" unless products.count.zero?
puts "  Filtered products: #{filtered_products_sum / filtered_products.count}" unless filtered_products.count.zero?
puts "Time wasted: #{time_wasted}"
