USING: ui ui.gadgets ui.gadgets.labels ui.gadgets.borders ui.gadgets.buttons ui.gadgets.packs accessors ;
IN: hello

: open-label-window ( -- )
  <pile> 1 >>fill
  "Factor Gadget" <label> 20 <border> add-gadget
  "OK" [ close-window ] <bevel-button> add-gadget
  "Alert" open-window ;

: open-hello-window ( -- )
  "Hello!" [ open-label-window ] <bevel-button> 
  "Factor" open-window ;

: hello ( -- )
  [ open-hello-window ] with-ui ;

hello
