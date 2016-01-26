class OrderMailer < ActionMailer::Base

  def email_pdf(email_recipient, user) # this method is informed by the $file_names in post_mailer folder
    attachments['this_is_the_amazing_pdf.pdf'] = File.read('tmp/x.pdf')
    mail(to: email_recipient.email,
        from: user.email, # if you use the gmail stmp, this will override
        subject: email_recipient.subject,
        body: email_recipient.content
    ) # the argument inside here is a hash, and the hash contents are the email contents
  end

end