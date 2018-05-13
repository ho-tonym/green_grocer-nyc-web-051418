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
      add_coupon = name + " W/COUPON"

      if cart[name] && cart[name][:count] >= coupon[:num] && cart[add_coupon] == nil
        cart[add_coupon] = cart[name].clone
        cart[add_coupon][:count] = 1
        cart[add_coupon][:price] = coupon[:cost]
          if cart[name][:count] >= coupon[:num]
            cart[name][:count] = cart[name][:count] - coupon[:num]
          end
      elsif cart[name] && cart[name][:count] >= coupon[:num]
        cart[add_coupon][:count] += 1
        cart[name][:count] = cart[name][:count] - coupon[:num]
      end
    end
  cart
end

def apply_clearance(cart)
  # code here
  cart.each do |name, data|
    if data[:clearance] == true
       data[:price] = (data[:price]*(0.8)).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  cart_1 =  consolidate_cart(cart)
  after_coupon = apply_coupons(cart_1, coupons)
  checkout = apply_clearance(after_coupon)

  cost = 0
  checkout.each do |key, value|
    cost += value[:price] * value[:count]
  end
    if cost > 100
      cost = cost*0.9
    end
  cost
end
