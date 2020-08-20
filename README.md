
# Explanation (per email)

  

#### I wanted to handle the gifting process as easily as I could think. I added the following fields because I believed I needed them before I could move on. (gift, gift_message, billing_address, billing_zipcode)

 - gift
 ##### This was specified within the requirements.  I wanted to be sure I knew the order was a gift, so I believed adding a boolean field was the best route to go here.
 - gift_message
 ##### An optional field that would allow the gifter to enter whatever message they wanted.
 - billing_address
 ##### I remember going through the checkout process myself and thinking that I typically needed to add my own address when submitting a payment.  I did a quick google search to confirm that it was needed, but it seemed like that was the case. This field is only required if the Order is a gift (validators are in there to confirm).
 - billing_zipcode
 ##### see `billing_address`

#### After getting the fields migrated, I wanted to change what was happening on the frontend to get a better picture of how I would expect things to work once I moved to the logic that would be implemented in the model.  I created a function that would detect a change in the "order_gift" box and adjust the existing fields as result by changing labels and display/hiding sections of the form.

### It's logic time
#### `Order` logic
##### For the `Order`, I was thinking of it as an area that has been in use so I wanted to add change that wouldn't break it, but also allow the new gifting functionality.  The logic would be moving into the `Order` function `#create_with_params` which would be returning an `Order` instance.  It functions in two ways:

 1. Non-gifted workflow - just create the `Order` as normal
 2. Gifted workflow - Check if the `Child` exists.  If not, return non-persisted `Order`.  If so, create the `Order` with the given parameters and return it.

##### Note: When returning a newly created gift `Order`, I would fetch the last placed `Order` and assign the address/zipcode for the new one from that last placed `Order`.

#### `Child` logic
##### For the `Child`, we stuck with the same gifted/non-gifted paths.  Non-gifted proceeded as normal, which is to take the params and create the `Child`.  The gifted path would use the child params given to find an existing `Child`.  If that `Child` did not exist, return it. If it did exist, return the existing `Child` record.

### Testing
##### I take a TDD approach so as I developed and changed each portion I was also creating tests to cover them.  I focused on the functions I created in the models first then moved the feature test.  I added `SimpleCov` mainly because I worked with it before and like to see what new code I've added isn't tested.  After getting my logic fully tested, I moved on to the feature tests and, in this case, there was a similar test in place at `purchase_product_spec.rb:56`.  I took that same test, tweaked some things (added existing `Order` and `Child` record), and altered the interaction (set `order_gift` to true).