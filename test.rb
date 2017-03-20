require 'bundler/setup'
Bundler.require :default

require 'rspec'
require 'dry/logic'
require 'dry/logic/predicates'
require 'dry-validation'
require 'reform'
require 'reform/form/dry'
Reform::Form.send :feature, Reform::Form::Dry

class Direction
end

RSpec.describe "type?" do
  let(:schema) do
    Dry::Validation.Schema do
      required(:facing).value(type?: Direction)
    end
  end

  class Form < Reform::Form
    # ::Dry::Types.register_class Direction
    property :facing, virtual: true
    validation do
      required(:facing).filled(type?: Direction)
    end
  end

  let(:input_valid)   { {facing: Direction.new} }
  let(:input_invalid) { {facing: Object.new} }

  it "as regular ruby" do
    expect(input_valid[:facing].class).to eq Direction
    expect(input_invalid[:facing].class).to_not eq Direction
  end

  it "with dry-validation" do
    expect(schema.call(input_valid).success?).to eq true
    expect(schema.call(input_invalid).success?).to eq false
  end

  it "with reform" do
    expect(Form.new(0).validate(input_valid)).to eq true
    expect(Form.new(0).validate(input_invalid)).to eq false
  end
end
