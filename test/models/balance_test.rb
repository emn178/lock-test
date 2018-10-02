require 'test_helper'

class BalanceTest < ActiveSupport::TestCase
  test "failed" do
    o = Balance.new(value: 100)
    o.save
    p o.value
    threads = []
    threads << Thread.new {
      o1 = Balance.lock.find(o.id)
      p o1.value
      o1.value -= 1
      o1.save
    }
    threads << Thread.new {
      o2 = Balance.lock.find(o.id)
      p o2.value
      o2.value -= 1
      o2.save
    }
    threads.each(&:join)
    o.reload
    p o.value
    assert o.value == 98
  end

  test "passed" do
    o = Balance.new(value: 100)
    o.save
    p o.value
    threads = []
    threads << Thread.new {
      o1 = Balance.find(o.id)
      o1.with_lock do
        p o1.value
        o1.value -= 1
        o1.save
      end
    }
    threads << Thread.new {
      o2 = Balance.find(o.id)
      o2.with_lock do
        p o2.value
        o2.value -= 1
        o2.save
      end
    }
    threads.each(&:join)
    o.reload
    p o.value
    assert o.value == 98
  end
end
