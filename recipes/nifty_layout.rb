stategies << lambda do
  generate "nifty:layout", "-f", "--haml"
  commit_all 'Add nifty layout'
end
