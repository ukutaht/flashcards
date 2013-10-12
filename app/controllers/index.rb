require 'pry'

get '/' do
  @decks = Deck.all
  erb :index
end


get '/decks/:deck_id' do
  @deck = Deck.find(params[:deck_id])
  erb :deck
end

get '/game_on/:deck_id' do
  @play_deck = Deck.find(params[:deck_id])
  @current_game = Game.create(deck_id: @play_deck.id)
  current_user.games << @current_game
  
  session[:game_id] = @current_game.id
  session[:card_number] = 0

  first_card = @play_deck.cards.first
  redirect to "/cards/#{first_card.id}"
end

get '/cards/:card_id' do
 @current_game = Game.find(session[:game_id])
 
 @card = Card.find(params[:card_id])
 erb :card

end


get '/results' do
  erb :results
end

post '/guess/:card_id' do
 @current_game = Game.find(session[:game_id])
 @card = @current_game.deck.cards.find(params[:card_id])
 
 session[:card_number] += 1
 @current_game.guesses << Guess.create(correct: @card.expected_answer == params[:answer])


  if @current_game.deck.cards.last == @card
   redirect to '/results'
  else 
    redirect to "/cards/#{@current_game.deck.cards[session[:card_number]].id}"
  end
end





############## SESSIONS ##################


get '/logout' do
  session.clear
  redirect to '/'
end

post '/login' do
  @current_user = User.find_by_user_name(params[:user][:user_name])
  
  session[:user_id] = @current_user.id

  redirect to '/'
end


get '/signup' do

  erb :signup
end






















