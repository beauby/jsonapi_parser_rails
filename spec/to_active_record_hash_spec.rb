require 'jsonapi_parser/rails'

describe JsonApiParser, '#to_active_record_hash' do
  before(:all) do
    @payload = {
      'data' => {
        'type' => 'posts',
        'id' => '1337',
        'attributes' => {
          'title' => 'Hello',
          'date' => 'today'
        },
        'relationships' => {
          'author' => {
            'data' => {
              'type' => 'users',
              'id' => '1'
            }
          },
          'comments' => {
            'data' => [
              { 'type' => 'comment', 'id' => '1' },
              { 'type' => 'comment', 'id' => '2' },
              { 'type' => 'comment', 'id' => '3' }
            ]
          }
        }
      }
    }
  end

  it 'works' do
    hash = JsonApiParser.document_to_active_record_hash(@payload)
    expect(hash.keys).to eq [:id, :title, :date, :author_id, :comment_ids]
    expect(hash[:id]).to eq '1337'
    expect(hash[:title]).to eq 'Hello'
    expect(hash[:date]).to eq 'today'
    expect(hash[:author_id]).to eq '1'
    expect(hash[:comment_ids]).to eq ['1', '2', '3']
  end
end
