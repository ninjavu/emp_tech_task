# frozen_string_literal: true

admin = Admin.create!(
  name: 'Mike'
)

merchant = Merchant.create!(
  name: 'Sam',
  description: 'Random'
)

User.create!(
  email: 'admin@emp.com',
  userable: admin
)

User.create!(
  email: 'merchant@emp.com',
  userable: merchant
)

10.times {
  Transaction::Charge.create!(
    customer_email: 'random@emp.com',
    amount: 1000,
    merchant:
  )
}
