class User < ApplicationRecord
  validates :address, presence: true, uniqueness: { case_sensitive: false }
  validates :email, 'valid_email_2/email': true, allow_blank: true
  validates :name, uniqueness: { case_sensitive: false }, allow_blank: true

  has_many :lists, foreign_key: :seller_id
  has_many :buy_orders, foreign_key: :buyer_id, class_name: 'Order'
  has_many :sell_orders, through: :lists, source: :orders
  has_many :user_disputes
  has_many :contracts

  def orders
    Order.left_joins(:list).where('orders.buyer_id = ? OR lists.seller_id = ?', id, id)
  end

  def image_url
    return unless image

    s3 = Aws::S3::Resource.new(
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: ENV['AWS_REGION']
    )

    bucket = s3.bucket(ENV['AWS_IMAGES_BUCKET'])
    obj = bucket.object(image)

    obj.presigned_url(:get, expires_in: 3600)
  end

  def self.find_or_create_by_address(address)
    User.where('lower(address) = ?', address.downcase).first ||
      User.create(address: Eth::Address.new(address).checksummed)
  end

  before_create do
    self.address = Eth::Address.new(self.address).checksummed
  end
end
