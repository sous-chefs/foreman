module Foreman
  def random_password(size = 32, non_ambiguous = false)
    characters = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    %w(I O l 0 1).each do |ambiguous_character|
      characters.delete ambiguous_character
    end if non_ambiguous

    size.times.collect do
      characters[rand(characters.size)]
    end.join
  end
end
