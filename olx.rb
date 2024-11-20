# frozen_string_literal: true

# Some modificated code from video https://www.youtube.com/watch?v=Eu9HIgSSx7Q

require 'watir'

start_script = Time.now

browser = Watir::Browser.new headless: false
browser.goto('https://www.olx.ua/uk/list/q-nikon-D3100-kit/')

if browser.button(data_testid: 'dismiss-cookies-banner').present?
  browser.button(data_testid: 'dismiss-cookies-banner').click
end

products = []

loop do
  parsed_products = browser.divs(class: 'css-qfzx1y')

  parsed_products.each do |pp|
    products << { name: pp.h4.text, price: pp.p.text.tr(' ', '').to_i }
  end

  break unless browser.a(data_testid: 'pagination-forward').present?

  browser.a(data_testid: 'pagination-forward').click
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
