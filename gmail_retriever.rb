require "mail"
require 'csv'


def write_row(mail, csv)
  data = []
  data << (mail.from ? mail.from.first : "")
  data << (mail.to ? mail.to.first : "")
  data << mail.date
  csv  << data
end



EMAIL_TO_RETRIEVE = 10
USER = '<username>'
PASS = '<password>'


Mail.defaults do
  retriever_method :imap,  :address     => "imap.gmail.com",
                           :port       => 993,
                           :user_name  => USER,
                           :password   => PASS,
                           :enable_ssl =>   true

end


{:inbox => 'INBOX', :sent => '[Gmail]/Sent Mail'}.each do |name,  mailbox|
  emails = Mail.find(:mailbox => mailbox,
                     :what  => :last,
                     :count => EMAIL_TO_RETRIEVE,
                     :order  => :dsc) 

  CSV.open("#{name}_data.csv", 'w') do |csv|
    csv << %w(from to date)
    emails.each do |mail|
      begin
        write_row(mail, csv)
      rescue
        puts "Cannot write this email -> #{mail.from} to #{mail.to} with subject: #{mail.subject}"
        puts $!
      end
    end
  end
end
