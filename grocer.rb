require 'pry'
def consolidate_cart(cart)

  items = {}

  cart.each do |description|
    description.each do |key, value|
      if items[key]
        items[key][:count] += 1
      else
        items[key] = value
        items[key][:count] = 1
      end
    end
  end
  return items
end


def apply_coupons(cart, coupons)
  coupons.each do |coupon|
      name = coupon[:item].clone
      add_c = "#{coupon[:item]} W/COUPON"

      if cart[name] && cart[name][:count] >= coupon[:num] && cart[add_c] == nil
        cart[add_c] = cart[name].clone
        cart[add_c][:count] = 1
        cart[add_c][:price] = coupon[:cost]
          if cart[name][:count] >= coupon[:num]
            cart[name][:count] = cart[name][:count] - coupon[:num]
          end
      elsif cart[name] && cart[name][:count] >= coupon[:num]
        cart[add_c][:count] += 1
        cart[name][:count] = cart[name][:count] - coupon[:num]
      end
    end
  cart
end

def apply_clearance(cart)
  hash = {}
    cart.each do |key, value|
      if value[:clearance] == true
        discount = (value[:price] * 0.8).round(2)
        hash[key] = value
        hash[key][:price] = discount
      else
        hash[key] = value
      end
    end
  hash
end

def checkout(cart, coupons)
  first_cart =  consolidate_cart(cart)
  second_cart = apply_coupons(first_cart, coupons)
  total = apply_clearance(first_cart)
  cost = 0
  total.each {|x, y| cost += (y[:price] * y[:count])}

    if cost > 100
      cost = cost*0.9
    end

  cost
end
