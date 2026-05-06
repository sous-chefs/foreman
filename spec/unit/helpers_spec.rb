# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../libraries/helpers'

describe ForemanCookbook::Helpers do
  subject(:helper) do
    Class.new do
      include ForemanCookbook::Helpers
    end.new
  end

  describe '#deep_merge' do
    it 'recursively merges nested hashes' do
      expect(
        helper.deep_merge(
          { database: { adapter: 'postgresql', port: nil }, service: true },
          { database: { port: 5432 } }
        )
      ).to eq(database: { adapter: 'postgresql', port: 5432 }, service: true)
    end
  end

  describe '#symbolize_keys' do
    it 'symbolizes nested hash keys' do
      expect(helper.symbolize_keys('database' => { 'adapter' => 'postgresql' })).to eq(
        database: { adapter: 'postgresql' }
      )
    end
  end

  describe '#database_real_adapter' do
    it 'maps legacy adapter names to gem adapter names' do
      expect(helper.database_real_adapter('sqlite')).to eq('sqlite3')
      expect(helper.database_real_adapter('mysql')).to eq('mysql2')
      expect(helper.database_real_adapter('postgresql')).to eq('postgresql')
    end
  end
end
