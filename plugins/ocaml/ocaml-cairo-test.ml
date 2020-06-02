(*
This file is part of MXE. See LICENSE.md for licensing information.
*)

let on_expose_event widget _ =
  let open Cairo in
  let drawable = widget#misc#window in
  let cr = Cairo_lablgtk.create drawable in
  let i = ref 1 in
  while !i <= 10 do
    let i' = float !i in
    set_source_rgba cr 0. 0. 1. (i'*.0.1);
    rectangle cr (50.*.i') 20. 40. 40.;
    fill cr;
    incr i
  done;
  false

let () =
  let window = GWindow.window
      ~title:"transparency"
      ~position:`CENTER () in
  ignore(window#event#connect#after#expose
       (on_expose_event window));
  ignore(window#connect#destroy GMain.quit);
  window#misc#set_app_paintable true;
  window#set_default_size ~width:590 ~height:80;
  window#show ();
  GMain.main ()
