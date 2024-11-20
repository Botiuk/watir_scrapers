# frozen_string_literal: true

# Some modificated code from video https://www.youtube.com/watch?v=Eu9HIgSSx7Q

require 'watir'

start_script = Time.now

browser = Watir::Browser.new headless: true
browser.goto('https://prom.ua/ua/search?search_term=Nikon%20D3100&category=1909')

products = []

loop do
  parsed_products = browser.div(data_qaid: 'product_gallery').divs(class: 'l-GwW')

  parsed_products.each do |pp|
    if pp.button(data_qaid: 'buy-button').present?
      products << { name: pp.span(data_qaid: 'product_name').text,
                    price: pp.div(data_qaid: 'product_price').span.text.tr(' ', '').to_i }
    end
  end

  break unless browser.div(data_qaid: 'pagination').present?

  if browser.a(data_qaid: 'next_page').present?
    browser.a(data_qaid: 'next_page').click
  else
    current_page = browser.div(class: 'MafxA _0NLAD WIR6H rLo4t GfiH9 ZNZm3').button(data_qaid: 'pages').text.to_i
    all_pages_collection = browser.div(class: 'MafxA _0NLAD WIR6H rLo4t GfiH9 ZNZm3').divs(class: 'l-GwW')
    page_numbers = []
    all_pages_collection.each do |number|
      page_numbers << number.a.text.to_i if number.a(data_qaid: 'pages').present?
    end

    break unless page_numbers.max > current_page

    browser.a(data_qaid: 'pages', text: page_numbers.max.to_s).click
  end
  sleep 3
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
