-module (hello).
-export ([start/0]).

start() ->
  S = gs:start(),
  
  Win = gs:window(S,[{title,"Erlang"},{width,150},{height,100}]),  
  gs:create(button,hello,Win,[{y,30},{x,50},{width,50},
		       {label,{text,"Hello!"}}]),
			       
  gs:config(Win,{map,true}),
  loop().


hello() ->
  S = gs:start(),

  Message = gs:window(S,[{title,"Hello"},{width,250},{height,70}]),
  gs:create(label,text,Message,[{y,0},{x,0},{width,250},
		       {label,{text,"Erlang Graphics System"}}]),
  gs:create(button,hellook,Message,[{y,30},{x,100},{width,50},
		       {label,{text,"OK"}}]),		       

  gs:config(Message,{map,true}).


loop() ->
  receive
    {gs,hello,_,_,_} -> hello();
    {gs,hellook,_,_,_} -> exit(normal)
  end,
  loop().