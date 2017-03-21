if Rails.env.development? || Rails.env.test?
  PutsDebuggerer.print_engine = :ap
  PutsDebuggerer.app_path = Rails.root.to_s
end
