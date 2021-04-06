require 'labor'
require 'overtime'
require 'timecop'

RSpec.describe Overtime do
  let(:labor) { Labor.new(48000)}
  
  describe '平常日的加班' do
    let(:overtime) { Overtime.new('平常日')}

    it '加班第1小時至第2小時，每小時平均工資*時數*1.34' do
      overtime.work(labor)
      Timecop.travel(110 * 60)
      overtime.getoff(labor)

      expect(labor).to be_off
      expect(labor.worked_for_seconds).to be 6600
      expect(overtime.payment).to be 536
    end

    it '加班第3小時至第4小時，每小時平均工資*時數*1.67' do
      overtime.work(labor)
      Timecop.travel(180 * 60)
      overtime.getoff(labor)

      # 前兩小時共 536 + 第三小時334 = 870
      expect(overtime.payment).to be 870
    end

  end


  describe '休息日的加班' do
    let(:overtime) { Overtime.new('休息日')}
    
    it '加班第1小時至第2小時，每小時平均工資*時數*1.34' do
      overtime.work(labor)
      Timecop.travel(120 * 60)
      overtime.getoff(labor)

      expect(overtime.payment).to be 536
    end

    it '加班第3小時至第8小時，每小時平均工資*時數*1.67' do
      overtime.work(labor)
      Timecop.travel(460 * 60)
      overtime.getoff(labor)

      # 前兩小時共 536 + 後六小時2004 = 868
      expect(overtime.payment).to be 2540
    end

    it '加班第9小時至第12小時，每小時平均工資*時數*2.67' do
      overtime.work(labor)
      Timecop.travel(680 * 60)
      overtime.getoff(labor)

      # 前兩小時共 536 + 中六小時2004 + 後三小時1602 = 4142
      expect(overtime.payment).to be 4142
    end

  end


  describe '休假日的加班' do
    let(:overtime) { Overtime.new('休假日')}
  
    it '加班第1小時至第8小時，不論加班多久均加給一日工資' do
      overtime.work(labor)
      Timecop.travel(400 * 60)
      overtime.getoff(labor)

      expect(overtime.payment).to be 1600
    end

    it '加班第9小時至第10小時，每小時平均工資*時數*2.34' do
      overtime.work(labor)
      Timecop.travel(580 * 60)
      overtime.getoff(labor)

      # 前八小時共 1600 + 後兩小時936 = 2536
      expect(overtime.payment).to be 2536
    end

    it '加班第11小時至第12小時，每小時平均工資*時數*2.67' do
      overtime.work(labor)
      Timecop.travel(720 * 60)
      overtime.getoff(labor)

      # 前八小時共 1600 + 中兩小時936 + 後兩小時1068 = 3604
      expect(overtime.payment).to be 3604
    end

  end


  describe '假日時因天災、事變或突發事件的加班' do
    let(:overtime) { Overtime.new('假日時因天災、事變或突發事件')}

    it '加班第1小時至第8小時，每小時平均工資*時數*2' do
      overtime.work(labor)
      Timecop.travel(250 * 60)
      overtime.getoff(labor)

      expect(overtime.payment).to be 1600
    end

    it '加班第9小時至第10小時，每小時平均工資*時數*2.34' do
      overtime.work(labor)
      Timecop.travel(600 * 60)
      overtime.getoff(labor)

      # 前八小時共3200  + 後兩小時936 = 4136
      expect(overtime.payment).to be 4136
    end

    it '加班第11小時至第12小時，每小時平均工資*時數*2.67' do
      overtime.work(labor)
      Timecop.travel(670 * 60)
      overtime.getoff(labor)

      # 前八小時共 3200 + 中兩小時936 + 後一小時534 = 4670
      expect(overtime.payment).to be 4670
    end

  end

end
