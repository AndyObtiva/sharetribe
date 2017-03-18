if Rails.env.development? || Rails.env.test?
  PutsDebuggerer.print_engine = :ap
end
