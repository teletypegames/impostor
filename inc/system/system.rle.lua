--- @section RLE
RLE = {}

--- Draws an RLE-encoded image.
--- @param runs table Array of run lengths.
--- @param values table Array of pixel values (colors).
function RLE.draw(img_values, img_runs)
    local SCREEN_WIDTH=240
    local SCREEN_HEIGHT=136
    local val_i=0
    local run=0
    for y=0,SCREEN_HEIGHT-1 do
        for x=0,SCREEN_WIDTH-1 do
            if run==0 then
                val_i=val_i+1
                run=img_runs[val_i]
            end
            run=run-1
            pix(x,y,img_values[val_i])
        end
    end
end
