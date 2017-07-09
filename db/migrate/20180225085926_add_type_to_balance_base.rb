class AddTypeToBalanceBase < ActiveRecord::Migration[5.1]
  def change
    add_column :balance_bases, :transaction_type, :string
    counter = BalanceBase.all.count
    puts "Duplicating #{counter} balances"
    BalanceBase.all.each_with_index do |balance, index|
      new = balance.dup
      new.transaction_type = 'flexible'
      new.save!
      puts "Duplicated #{index} (#{(index/counter.to_f*100).round(2)}%) balances"
    end
  end
end
