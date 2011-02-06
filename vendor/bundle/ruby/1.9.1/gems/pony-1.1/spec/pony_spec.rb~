require File.dirname(__FILE__) + '/base'

describe Pony do
	it "sends mail" do
		Pony.should_receive(:transport) do |tmail|
			tmail.to.should == [ 'joe@example.com' ]
			tmail.from.should == [ 'sender@example.com' ]
			tmail.subject.should == 'hi'
			tmail.body.should == 'Hello, Joe.'
		end
		Pony.mail(:to => 'joe@example.com', :from => 'sender@example.com', :subject => 'hi', :body => 'Hello, Joe.')
	end

	it "requires :to param" do
		Pony.stub!(:transport)
		lambda { Pony.mail({}) }.should raise_error(ArgumentError)
	end

	it "doesn't require any other param" do
		Pony.stub!(:transport)
		lambda { Pony.mail(:to => 'joe@example.com') }.should_not raise_error
	end

	####################

	describe "builds a TMail object with field:" do
		it "to" do
			Pony.build_tmail(:to => 'joe@example.com').to.should == [ 'joe@example.com' ]
		end
		
		it "to with multiple recipients" do
			Pony.build_tmail(:to => 'joe@example.com, friedrich@example.com').to.should == [ 'joe@example.com', 'friedrich@example.com' ]
		end
		
		it "to with multiple recipients and names" do
			Pony.build_tmail(:to => 'joe@example.com, "Friedrich Hayek" <friedrich@example.com>').to.should == [ 'joe@example.com', 'friedrich@example.com' ]
		end
		
		it "to with multiple recipients and names in an array" do
			Pony.build_tmail(:to => ['joe@example.com', '"Friedrich Hayek" <friedrich@example.com>']).to.should == [ 'joe@example.com', 'friedrich@example.com' ]
		end

		it "cc" do
			Pony.build_tmail(:cc => 'joe@example.com').cc.should == [ 'joe@example.com' ]
		end
		
		it "cc with multiple recipients" do
			Pony.build_tmail(:cc => 'joe@example.com, friedrich@example.com').cc.should == [ 'joe@example.com', 'friedrich@example.com' ]
		end

		it "from" do
			Pony.build_tmail(:from => 'joe@example.com').from.should == [ 'joe@example.com' ]
		end

		it "bcc" do
			Pony.build_tmail(:bcc => 'joe@example.com').bcc.should == [ 'joe@example.com' ]
		end

		it "bcc with multiple recipients" do
			Pony.build_tmail(:bcc => 'joe@example.com, friedrich@example.com').bcc.should == [ 'joe@example.com', 'friedrich@example.com' ]
		end

		it "charset" do
			Pony.build_tmail(:charset => 'UTF-8').charset.should == 'UTF-8'
		end

		it "default charset" do
			Pony.build_tmail(:body => 'body').charset.should == nil
			Pony.build_tmail(:body => 'body', :content_type => 'text/html').charset.should == nil
		end

		it "from (default)" do
			Pony.build_tmail({}).from.should == [ 'pony@unknown' ]
		end

		it "subject" do
			Pony.build_tmail(:subject => 'hello').subject.should == 'hello'
		end

		it "body" do
			Pony.build_tmail(:body => 'What do you know, Joe?').body.should == 'What do you know, Joe?'
		end

		it "content_type" do
			Pony.build_tmail(:content_type => 'text/html').content_type.should == 'text/html'
		end

		it "message_id" do
			Pony.build_tmail(:message_id => '<abc@def.com>').message_id.should == '<abc@def.com>'
		end

		it "custom headers" do
			Pony.build_tmail(:headers => {"List-ID" => "<abc@def.com>"})['List-ID'].to_s.should == '<abc@def.com>'
		end

		it "attachments" do
			tmail = Pony.build_tmail(:attachments => {"foo.txt" => "content of foo.txt"})
			tmail.should have(2).parts
			tmail.parts.first.to_s.should == "Content-Type: text/plain\n\n"
			tmail.parts.last.to_s.should == <<-PART
Content-Type: text/plain
Content-Transfer-Encoding: Base64
Content-Disposition: attachment; filename=foo.txt

Y29udGVudCBvZiBmb28udHh0
			 PART
		end

		it "suggests mime-type" do
			tmail = Pony.build_tmail(:attachments => {"foo.pdf" => "content of foo.pdf"})
			tmail.should have(2).parts
			tmail.parts.first.to_s.should == "Content-Type: text/plain\n\n"
			tmail.parts.last.to_s.should == <<-PART
Content-Type: application/pdf
Content-Transfer-Encoding: Base64
Content-Disposition: attachment; filename=foo.pdf

Y29udGVudCBvZiBmb28ucGRm
			 PART
		end
	end

	describe "transport" do
		it "transports via the sendmail binary if it exists" do
			File.stub!(:executable?).and_return(true)
			Pony.should_receive(:transport_via_sendmail).with(:tmail)
			Pony.transport(:tmail)
		end

		it "transports via smtp if no sendmail binary" do
			Pony.stub!(:sendmail_binary).and_return('/does/not/exist')
			Pony.should_receive(:transport_via_smtp).with(:tmail)
			Pony.transport(:tmail)
		end

		it "transports mail via /usr/sbin/sendmail binary" do
			pipe = mock('sendmail pipe')
			IO.should_receive(:popen).with('-',"w+").and_yield(pipe)
			pipe.should_receive(:write).with('message')
			Pony.transport_via_sendmail(mock('tmail', :to => ['to'], :from => ['from'], :to_s => 'message'))
		end

		describe "SMTP transport" do
			before do
				@smtp = mock('net::smtp object')
				@smtp.stub!(:start)
				@smtp.stub!(:send_message)
				@smtp.stub!(:finish)
				Net::SMTP.stub!(:new).and_return(@smtp)
			end

			it "passes cc and bcc as the list of recipients" do
				@smtp.should_receive(:send_message).with("message", ['from'], ['to', 'cc', 'bcc'])
				Pony.transport_via_smtp(mock('tmail', :to => ['to'], :cc => ['cc'], :from => ['from'], :to_s => 'message', :bcc => ['bcc'], :destinations => ['to', 'cc', 'bcc']))
				@smtp.should_receive(:send_message).with("message", 'from', ['to', 'cc'])
				Pony.transport_via_smtp(mock('tmail', :to => 'to', :cc => 'cc', :from => 'from', :to_s => 'message', :bcc => nil, :destinations => ['to', 'cc']))
			end

			it "only pass cc as the list of recipients" do
				@smtp.should_receive(:send_message).with("message", ['from'], ['to', 'cc' ])
					Pony.transport_via_smtp(mock('tmail', :to => ['to'], :cc => ['cc'], :from => ['from'], :to_s => 'message', :bcc => nil, :destinations => ['to', 'cc']))
			end

			it "only pass bcc as the list of recipients" do
				@smtp.should_receive(:send_message).with("message", ['from'], ['to', 'bcc' ])
					Pony.transport_via_smtp(mock('tmail', :to => ['to'], :cc => nil, :from => ['from'], :to_s => 'message', :bcc => ['bcc'], :destinations => ['to', 'bcc']))
			end

			it "passes cc and bcc as the list of recipients when there are a few of them" do
				@smtp.should_receive(:send_message).with("message", ['from'], ['to', 'to2', 'cc', 'bcc', 'bcc2', 'bcc3'])
					Pony.transport_via_smtp(mock('tmail', :to => ['to', 'to2'], :cc => ['cc'], :from => ['from'], :to_s => 'message', :bcc => ['bcc', 'bcc2', 'bcc3'], :destinations => ['to', 'to2', 'cc', 'bcc', 'bcc2', 'bcc3']))
			end

			it "defaults to localhost as the SMTP server" do
				Net::SMTP.should_receive(:new).with('localhost', '25').and_return(@smtp)
				Pony.transport_via_smtp(mock('tmail', :to => ['to'], :from => ['from'], :to_s => 'message', :cc => nil, :bcc => nil, :destinations => ['to']))
			end

			it "uses SMTP authorization when auth key is provided" do
				o = { :smtp => { :user => 'user', :password => 'password', :auth => 'plain'}}
				@smtp.should_receive(:start).with('localhost.localdomain', 'user', 'password', 'plain')
				Pony.transport_via_smtp(mock('tmail', :to => ['to'], :from => ['from'], :to_s => 'message', :cc => nil, :bcc => nil, :destinations => ['to']), o)
			end

			it "enable starttls when tls option is true" do
				o = { :smtp => { :user => 'user', :password => 'password', :auth => 'plain', :tls => true}}
				@smtp.should_receive(:enable_starttls)
				Pony.transport_via_smtp(mock('tmail', :to => ['to'], :from => ['from'], :to_s => 'message', :cc => nil, :bcc => nil, :destinations => ['to']), o)
			end

			it "starts the job" do
				@smtp.should_receive(:start)
				Pony.transport_via_smtp(mock('tmail', :to => ['to'], :from => ['from'], :to_s => 'message', :cc => nil, :bcc => nil, :destinations => ['to']))
			end

			it "sends a tmail message" do
				@smtp.should_receive(:send_message)
				Pony.transport_via_smtp(mock('tmail', :to => ['to'], :from => ['from'], :to_s => 'message', :cc => nil, :bcc => nil, :destinations => ['to']))
			end

			it "finishes the job" do
				@smtp.should_receive(:finish)
				Pony.transport_via_smtp(mock('tmail', :to => ['to'], :from => ['from'], :to_s => 'message', :cc => nil, :bcc => nil, :destinations => ['to']))
			end

		end
	end

	describe ":via option should over-ride the default transport mechanism" do
		it "should send via sendmail if :via => sendmail" do
			Pony.should_receive(:transport_via_sendmail)
			Pony.mail(:to => 'joe@example.com', :via => :sendmail)
		end

		it "should send via smtp if :via => smtp" do
			Pony.should_receive(:transport_via_smtp)
			Pony.mail(:to => 'joe@example.com', :via => :smtp)
		end

		it "should raise an error if via is neither smtp nor sendmail" do
			lambda { Pony.mail(:to => 'joe@plumber.com', :via => :pigeon) }.should raise_error(ArgumentError)
		end
	end

	describe "sendmail binary location" do
		it "should default to /usr/sbin/sendmail if not in path" do
			Pony.stub!(:'`').and_return('')
			Pony.sendmail_binary.should == '/usr/sbin/sendmail'
		end
	end

end
