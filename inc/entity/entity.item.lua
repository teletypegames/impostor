function Item.use()
  Print.text("Used item: " .. Context.dialog.active_entity.name)
end
function Item.look_at()
  PopupWindow.show_description_dialog(Context.dialog.active_entity, Context.dialog.active_entity.desc)
end

