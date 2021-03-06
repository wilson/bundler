require File.expand_path('../../spec_helper', __FILE__)

describe "environment.rb file" do
  before :each do
    system_gems "rack-1.0.0"

    install_gemfile <<-G
      source "file://#{gem_repo1}"

      gem "activesupport", "2.3.5"
    G

    bundle :lock
  end

  it "does not pull in system gems" do
    run <<-R, :lite_runtime => true
      require 'rubygems'

      begin;
        require 'rack'
      rescue LoadError
        puts 'WIN'
      end
    R

    out.should == "WIN"
  end

  it "provides a gem method" do
    run <<-R, :lite_runtime => true
      gem 'activesupport'
      require 'activesupport'
      puts ACTIVESUPPORT
    R

    out.should == "2.3.5"
  end

  it "raises an exception if gem is used to invoke a system gem not in the bundle" do
    run <<-R, :lite_runtime => true
      begin
        gem 'rack'
      rescue LoadError => e
        puts e.message
      end
    R

    out.should == "rack is not part of the bundle. Add it to Gemfile."
  end
end
