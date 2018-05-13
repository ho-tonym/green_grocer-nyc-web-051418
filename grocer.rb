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
    items
end


def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart[coupon[:item]] != nil 
      if coupon[:num] <= cart[coupon[:item]][:count] 
        cart[coupon[:item]][:count] = cart[coupon[:item]][:count] - coupon[:num]
        insert_coupon = "#{coupon[:item]} W/COUPON"
        if cart[insert_coupon] != nil 
          cart[insert_coupon][:count] += 1
        else
          cart[insert_coupon] = {}
          cart[insert_coupon][:price] = coupon[:cost]
          cart[insert_coupon][:count] = 1
          cart[insert_coupon][:clearance] = cart[coupon[:item]][:clearance]
        end
      end
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
