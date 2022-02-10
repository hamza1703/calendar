require_relative('../calendar')

RSpec.describe Calendar do
  before(:example) do
    @calendar = Calendar.new
    # @calendar.add_event(Date.parse('26/08/2021'), 'Meeting')
  end

  it 'returns Successfully added an event' do
    expect(@calendar.add_event(Date.parse('26/08/2021'), 'New Meeting')).to eq "Successfully added an event"
  end

  it 'returns Successfully removed' do
    expect(@calendar.remove(Date.parse('10/10/2022'),[1,2],0)).to eq "Successfully removed"
  end

  it 'returns Successfully updated ' do
    expect(@calendar.update(Date.parse('10/10/2022'),[1],0, "updated event")).to eq "Successfully updated"
  end

  it 'returns false if try to delete an event that doesnt exist' do
    expect(@calendar.remove(Date.parse('12/12/2030'),[1,2],0)).to eq false
  end

  it 'returns false if try to delete an event that doesnt exist' do  
    expect(@calendar.update(Date.parse('12/12/2031'),[3,4,5],0, "updated event")).to eq false
  end

end