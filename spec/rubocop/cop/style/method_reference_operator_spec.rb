# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Style::MethodReferenceOperator, :ruby27 do
  subject(:cop) { described_class.new }

  context 'target_ruby_version < 2.7', :ruby26 do
    # TODO: wait 2.7 support
    pending 'allows method method' do
      expect_no_offenses(<<-RUBY.strip_indent)
        42.method(:to_s)
        42.method("to_s")
      RUBY
    end
  end

  it 'registers an offense when method method is called with a symbol' do
    expect_offense(<<-RUBY.strip_indent)
      42.method(:to_s)
        ^^^^^^^^^^^^^^ Prefer `.:to_s` over `.method(:to_s)`
    RUBY
  end

  it 'registers an offense when method method is called with a string' do
    expect_offense(<<-RUBY.strip_indent)
      42.method("to_s")
        ^^^^^^^^^^^^^^^ Prefer `.:to_s` over `.method("to_s")`
    RUBY
  end

  it 'allows method method with a symbol that contains space' do
    expect_no_offenses('42.method(:"foo bar")')
  end

  it 'allows method method with a string that contains space' do
    expect_no_offenses('42.method("foo bar")')
  end

  it 'auto-corrects a method method with a symbol to .:' do
    new_source = autocorrect_source('42.method(:to_s)')
    expect(new_source).to eq('42.:to_s')
  end

  it 'auto-corrects a method method with a string to .:' do
    new_source = autocorrect_source('42.method("to_s")')
    expect(new_source).to eq('42.:to_s')
  end
end
