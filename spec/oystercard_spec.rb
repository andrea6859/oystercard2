
require 'oystercard.rb'

describe Oystercard do
  let(:entry_station) {double :station}
  let(:exit_station) {double :station}
  let(:journey){ {entry: entry_station, exit: exit_station}}

  it 'checks default balance of Oystercard is 0' do
    expect(subject.balance).to eq 0
  end

  it 'checks that the card has an empty list of journeys' do
    expect(subject.journeys).to be_empty
  end

  it 'adds money to my oyster card' do
    expect{ subject.top_up 1 }.to change{ subject.balance }.by 1
  end



  it 'checks that touching in and out creates one journey' do
    subject.top_up(20)
    subject.touch_in(entry_station)
    subject.touch_out(exit_station)
    expect(subject.journeys).to include journey
  end

    describe '#top_up' do

      before do
        subject.top_up(Oystercard::BALANCE_LIMIT)
      end

      it 'will not allow a balance to exceed 90' do
        expect{ subject.top_up 1 }.to raise_error "Your top up will exceed balance limit of #{Oystercard::BALANCE_LIMIT}!"
      end
    end

  describe '#touch_in' do
      let(:station) {double :station}
      let(:Journey_class) {double :Journey_class, new: journey2}
      let(:journey2) {double :journey2, start: nil}


    it 'raises an error if minimum balance on oystercard is less than 1' do
      expect{subject.touch_in(station)}.to raise_error 'you have insufficient funds on your oystercard'
    end

    xit 'send station to journey' do
      subject.top_up(10)
      subject.touch_in(station)
      expect(journey2).to have_received(:start).with(station)
    end


  end



  describe '#touch_out' do

    it 'updates balance by deducting fare' do
      subject.top_up(Journey::MIN_FARE)
      subject.touch_in(entry_station)
      expect{ subject.touch_out(exit_station) }.to change{ subject.balance }.by (-Journey::MIN_FARE)
    end

    it 'creates penalty fare if touch in and haven not touched out' do
      subject.top_up(20)
      subject.touch_in(entry_station)
      expect{ subject.touch_in(entry_station) }.to change{ subject.balance }.by (-Journey::PENALTY_FARE)
    end

      it 'creates penalty fare if touch out and haven not touched in' do
        subject.top_up(20)
        expect{ subject.touch_out(exit_station) }.to change{ subject.balance }.by (-Journey::PENALTY_FARE)
      end



    end

  end
