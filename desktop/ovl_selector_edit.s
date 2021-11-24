;;; ============================================================
;;; Overlay for Selector Edit - drives File Picker dialog
;;;
;;; Compiled as part of desktop.s
;;; ============================================================

.proc SelectorOverlay
        .org $7000

.proc Init
        stx     which_run_list
        sty     copy_when
        jsr     file_dialog::OpenWindow
        jsr     L7101
        jsr     L70AD
        jsr     file_dialog::DeviceOnLine
        lda     path_buf0
        beq     finish
        ldy     path_buf0
:       lda     path_buf0,y
        sta     file_dialog::path_buf,y
        dey
        bpl     :-

        jsr     file_dialog::StripPathSegment
        ldy     path_buf0
:       lda     path_buf0,y
        cmp     #'/'
        beq     found_slash
        dey
        cpy     #$01
        bne     :-

        lda     #$00
        sta     path_buf0
        jmp     finish

found_slash:
        ldx     #$00
:       iny
        inx
        lda     path_buf0,y
        sta     buffer,x
        cpy     path_buf0
        bne     :-
        stx     buffer

finish: jsr     file_dialog::ReadDir
        lda     #$00
        bcs     :+
        param_call file_dialog::FindFilenameIndex, buffer
        sta     selected_index
        jsr     file_dialog::CalcTopIndex
:       jsr     file_dialog::UpdateScrollbar2
        jsr     file_dialog::UpdateDiskName
        jsr     file_dialog::DrawListEntries
        lda     path_buf0
        bne     :+
        jsr     file_dialog::jt_prep_path
:       copy    #1, path_buf2
        copy    #' ', path_buf2+1
        jsr     file_dialog::jt_redraw_input
        jsr     file_dialog::RedrawF2
        copy    #1, path_buf2
        copy    #kGlyphInsertionPoint, path_buf2+1
        lda     #$FF
        sta     LD8EC
        jsr     file_dialog::InitDeviceNumber
        jmp     file_dialog::EventLoop

buffer: .res 16, 0

.endproc

;;; ============================================================

.proc L70AD
        ldx     jt_pathname
:       lda     jt_pathname+1,x
        sta     file_dialog::jump_table,x
        dex
        lda     jt_pathname+1,x
        sta     file_dialog::jump_table,x
        dex
        dex
        bpl     :-

        copy    #0, file_dialog::focus_in_input2_flag
        copy    #$80, file_dialog::dual_inputs_flag
        copy    #1, path_buf2
        copy    #kGlyphInsertionPoint, path_buf2+1
        lda     winfo_file_dialog::window_id
        jsr     file_dialog::SetPortForWindow
        lda     which_run_list
        jsr     ToggleRunListButton
        lda     copy_when
        jsr     ToggleCopyWhenButton
        copy    #$80, file_dialog::extra_controls_flag
        copy16  #HandleClick, file_dialog::click_handler_hook+1
        copy16  #HandleKey, file_dialog::HandleKey::key_meta_digit+1
        rts
.endproc

;;; ============================================================

.proc L7101
        lda     winfo_file_dialog::window_id
        jsr     file_dialog::SetPortForWindow
        lda     path_buf0
        beq     add
        param_call file_dialog::DrawTitleCentered, label_edit
        jmp     common

add:    param_call file_dialog::DrawTitleCentered, label_add
common: MGTK_RELAY_CALL MGTK::SetPenMode, penXOR
        MGTK_RELAY_CALL MGTK::FrameRect, file_dialog_res::input1_rect
        MGTK_RELAY_CALL MGTK::FrameRect, file_dialog_res::input2_rect
        param_call file_dialog::DrawInput1Label, enter_the_full_pathname_label
        param_call file_dialog::DrawInput2Label, enter_the_name_to_appear_label

        MGTK_RELAY_CALL MGTK::MoveTo, add_a_new_entry_to_label_pos
        param_call file_dialog::DrawString, add_a_new_entry_to_label_str
        MGTK_RELAY_CALL MGTK::MoveTo, primary_run_list_label_pos
        param_call file_dialog::DrawString, primary_run_list_label_str
        MGTK_RELAY_CALL MGTK::MoveTo, secondary_run_list_label_pos
        param_call file_dialog::DrawString, secondary_run_list_label_str
        MGTK_RELAY_CALL MGTK::MoveTo, down_load_label_pos
        param_call file_dialog::DrawString, down_load_label_str
        MGTK_RELAY_CALL MGTK::MoveTo, at_first_boot_label_pos
        param_call file_dialog::DrawString, at_first_boot_label_str
        MGTK_RELAY_CALL MGTK::MoveTo, at_first_use_label_pos
        param_call file_dialog::DrawString, at_first_use_label_str
        MGTK_RELAY_CALL MGTK::MoveTo, never_label_pos
        param_call file_dialog::DrawString, never_label_str

        MGTK_RELAY_CALL MGTK::SetPenMode, penXOR
        MGTK_RELAY_CALL MGTK::FrameRect, rect_primary_run_list_radiobtn
        MGTK_RELAY_CALL MGTK::FrameRect, rect_secondary_run_list_radiobtn
        MGTK_RELAY_CALL MGTK::FrameRect, rect_at_first_boot_radiobtn
        MGTK_RELAY_CALL MGTK::FrameRect, rect_at_first_use_radiobtn
        MGTK_RELAY_CALL MGTK::FrameRect, rect_never_radiobtn
        MGTK_RELAY_CALL MGTK::InitPort, main_grafport
        MGTK_RELAY_CALL MGTK::SetPort, main_grafport
        rts
.endproc

;;; ============================================================

        ;; Unused
        .byte   0

jt_pathname:
        .byte file_dialog::kJumpTableSize-1
        jump_table_entry HandleOkFilename
        jump_table_entry HandleCancelFilename
        jump_table_entry file_dialog::BlinkF1IP
        jump_table_entry file_dialog::RedrawF1
        jump_table_entry file_dialog::StripF1PathSegment
        jump_table_entry file_dialog::handle_f1_selection_change
        jump_table_entry file_dialog::PrepPathBuf0
        jump_table_entry file_dialog::HandleF1OtherKey
        jump_table_entry file_dialog::HandleF1DeleteKey
        jump_table_entry file_dialog::HandleF1LeftKey
        jump_table_entry file_dialog::HandleF1RightKey
        jump_table_entry file_dialog::HandleF1MetaLeftKey
        jump_table_entry file_dialog::HandleF1MetaRightKey
        jump_table_entry file_dialog::HandleF1Click
        .assert * - jt_pathname = file_dialog::kJumpTableSize+1, error, "Table size error"

jt_entry_name:
        .byte file_dialog::kJumpTableSize-1
        jump_table_entry HandleOkName
        jump_table_entry HandleCancelName
        jump_table_entry file_dialog::BlinkF2IP
        jump_table_entry file_dialog::RedrawF2
        jump_table_entry file_dialog::StripF2PathSegment
        jump_table_entry file_dialog::handle_f2_selection_change
        jump_table_entry file_dialog::PrepPathBuf1
        jump_table_entry file_dialog::HandleF2OtherKey
        jump_table_entry file_dialog::HandleF2DeleteKey
        jump_table_entry file_dialog::HandleF2LeftKey
        jump_table_entry file_dialog::HandleF2RightKey
        jump_table_entry file_dialog::HandleF2MetaLeftKey
        jump_table_entry file_dialog::HandleF2MetaRightKey
        jump_table_entry file_dialog::HandleF2Click
        .assert * - jt_entry_name = file_dialog::kJumpTableSize+1, error, "Table size error"

;;; ============================================================

.proc HandleOkFilename
        jsr     file_dialog::MoveIPToEndF1

        copy    #1, path_buf2
        copy    #' ', path_buf2+1
        jsr     file_dialog::jt_redraw_input

        ldx     jt_entry_name
:       lda     jt_entry_name+1,x
        sta     file_dialog::jump_table,x
        dex
        lda     jt_entry_name+1,x
        sta     file_dialog::jump_table,x
        dex
        dex
        bpl     :-

        lda     #$80
        sta     file_dialog::focus_in_input2_flag
        sta     file_dialog::L5105
        lda     LD8F0
        sta     LD8F1
        lda     #$00
        sta     LD8F0
        lda     path_buf1
        bne     finish
        lda     #$00
        sta     path_buf1
        ldx     path_buf0
        beq     finish
:       lda     path_buf0,x
        cmp     #'/'
        beq     found_slash
        dex
        bne     :-
        jmp     finish

found_slash:
        ldy     #0
:       iny
        inx
        lda     path_buf0,x
        sta     path_buf1,y
        cpx     path_buf0
        bne     :-

        sty     path_buf1
finish: copy    #1, path_buf2
        copy    #kGlyphInsertionPoint, path_buf2+1
        jsr     file_dialog::jt_redraw_input
        rts
.endproc

;;; ============================================================
;;; Close window and finish (via saved_stack) if OK
;;; Outputs: A = 0 if OK
;;;          X = which run list (1=primary, 2=secondary)
;;;          Y = copy when (1=boot, 2=use, 3=never)

.proc HandleOkName
        param_call file_dialog::L647C, path_buf0
        bne     invalid
        lda     path_buf1
        beq     fail
        cmp     #$0F            ; Max selector name length
        bcs     too_long
        jmp     ok

invalid:
        lda     #ERR_INVALID_PATHNAME
        jsr     JUMP_TABLE_SHOW_ALERT
fail:   rts

too_long:
        lda     #kErrNameTooLong
        jsr     JUMP_TABLE_SHOW_ALERT
        rts

ok:     MGTK_RELAY_CALL MGTK::InitPort, main_grafport
        MGTK_RELAY_CALL MGTK::SetPort, main_grafport
        MGTK_RELAY_CALL MGTK::CloseWindow, winfo_file_dialog_listbox
        MGTK_RELAY_CALL MGTK::CloseWindow, winfo_file_dialog
        sta     LD8EC
        jsr     file_dialog::SetCursorPointer
        copy16  #file_dialog::NoOp, file_dialog::HandleKey::key_meta_digit+1

        ldx     file_dialog::stash_stack
        txs
        ldx     which_run_list
        ldy     copy_when
        return  #0
.endproc

;;; ============================================================

.proc HandleCancelFilename
        MGTK_RELAY_CALL MGTK::InitPort, main_grafport
        MGTK_RELAY_CALL MGTK::SetPort, main_grafport
        MGTK_RELAY_CALL MGTK::CloseWindow, winfo_file_dialog_listbox
        MGTK_RELAY_CALL MGTK::CloseWindow, winfo_file_dialog
        lda     #0
        sta     LD8EC
        jsr     file_dialog::SetCursorPointer
        copy16  #file_dialog::NoOp, file_dialog::HandleKey::key_meta_digit+1
        ldx     file_dialog::stash_stack
        txs
        return  #$FF
.endproc

;;; ============================================================

.proc HandleCancelName
        jsr     file_dialog::MoveIPToEndF2

        copy    #1, path_buf2
        copy    #' ', path_buf2+1
        jsr     file_dialog::jt_redraw_input

        ldx     jt_pathname
:       lda     jt_pathname+1,x
        sta     file_dialog::jump_table,x
        dex
        lda     jt_pathname+1,x
        sta     file_dialog::jump_table,x
        dex
        dex
        bpl     :-

        copy    #1, path_buf2
        copy    #kGlyphInsertionPoint, path_buf2+1
        jsr     file_dialog::jt_redraw_input
        lda     #$00
        sta     file_dialog::L5105
        sta     file_dialog::focus_in_input2_flag
        lda     LD8F1
        sta     LD8F0
        rts
.endproc

;;; ============================================================

which_run_list:
        .byte   0
copy_when:
        .byte   0

;;; ============================================================

.proc HandleClick
        MGTK_RELAY_CALL MGTK::InRect, rect_primary_run_list_ctrl
        cmp     #MGTK::inrect_inside
        bne     :+
        jmp     ClickPrimaryRunListCtrl
:       MGTK_RELAY_CALL MGTK::InRect, rect_secondary_run_list_ctrl
        cmp     #MGTK::inrect_inside
        bne     :+
        jmp     ClickSecondaryRunListCtrl
:       MGTK_RELAY_CALL MGTK::InRect, rect_at_first_boot_ctrl
        cmp     #MGTK::inrect_inside
        bne     :+
        jmp     ClickAtFirstBootCtrl
:       MGTK_RELAY_CALL MGTK::InRect, rect_at_first_use_ctrl
        cmp     #MGTK::inrect_inside
        bne     :+
        jmp     ClickAtFirstUseCtrl
:       MGTK_RELAY_CALL MGTK::InRect, rect_never_ctrl
        cmp     #MGTK::inrect_inside
        bne     :+
        jmp     ClickNeverCtrl
:       return  #0
.endproc

.proc ClickPrimaryRunListCtrl
        lda     which_run_list
        cmp     #1
        beq     :+
        jsr     ToggleRunListButton
        lda     #1
        sta     which_run_list
        jsr     ToggleRunListButton
:       return  #$FF
.endproc

.proc ClickSecondaryRunListCtrl
        lda     which_run_list
        cmp     #2
        beq     :+
        jsr     ToggleRunListButton
        lda     #2
        sta     which_run_list
        jsr     ToggleRunListButton
:       return  #$FF
.endproc

.proc ClickAtFirstBootCtrl
        lda     copy_when
        cmp     #1
        beq     :+
        jsr     ToggleCopyWhenButton
        lda     #1
        sta     copy_when
        jsr     ToggleCopyWhenButton
:       return  #$FF
.endproc

.proc ClickAtFirstUseCtrl
        lda     copy_when
        cmp     #2
        beq     :+
        jsr     ToggleCopyWhenButton
        lda     #2
        sta     copy_when
        jsr     ToggleCopyWhenButton
:       return  #$FF
.endproc

.proc ClickNeverCtrl
        lda     copy_when
        cmp     #3
        beq     :+
        jsr     ToggleCopyWhenButton
        lda     #3
        sta     copy_when
        jsr     ToggleCopyWhenButton
:       return  #$FF
.endproc

;;; ============================================================

.proc ToggleRunListButton
        cmp     #1
        bne     :+
        param_call DrawInsetRect, rect_primary_run_list_radiobtn
        rts

:       param_call DrawInsetRect, rect_secondary_run_list_radiobtn
        rts
.endproc

.proc ToggleCopyWhenButton
        cmp     #1
        bne     :+
        param_call DrawInsetRect, rect_at_first_boot_radiobtn
        rts

:       cmp     #2
        bne     :+
        param_call DrawInsetRect, rect_at_first_use_radiobtn
        rts

:       param_call DrawInsetRect, rect_never_radiobtn
        rts
.endproc

;;; ============================================================
;;; Draw rect inset by 2px. Pointer to Rect in A,X.

.proc DrawInsetRect
        ptr := $06

        ;; Copy to scratch rect
        stax    ptr
        ldy     #.sizeof(MGTK::Rect)-1
:       lda     (ptr),y
        sta     rect_scratch,y
        dey
        bpl     :-

        lda     rect_scratch::x1
        clc
        adc     #2
        sta     rect_scratch::x1
        bcc     :+
        inc     rect_scratch::x1+1

:       lda     rect_scratch::y1
        clc
        adc     #2
        sta     rect_scratch::y1
        bcc     :+
        inc     rect_scratch::y1+1

:       lda     rect_scratch::x2
        sec
        sbc     #2
        sta     rect_scratch::x2
        bcs     :+
        dec     rect_scratch::x2+1

:       lda     rect_scratch::y2
        sec
        sbc     #2
        sta     rect_scratch::y2
        bcs     :+
        dec     rect_scratch::y2+1

:       MGTK_RELAY_CALL MGTK::SetPenMode, penXOR
        MGTK_RELAY_CALL MGTK::PaintRect, rect_scratch
        rts
.endproc

;;; ============================================================

.proc HandleKey
        lda     winfo_file_dialog::window_id
        jsr     file_dialog::SetPortForWindow
        lda     event_modifiers
        bne     :+
        rts

:       lda     event_key
        cmp     #'1'
        bne     :+
        jmp     ClickPrimaryRunListCtrl

:       cmp     #'2'
        bne     :+
        jmp     ClickSecondaryRunListCtrl

:       cmp     #'3'
        bne     :+
        jmp     ClickAtFirstBootCtrl

:       cmp     #'4'
        bne     :+
        jmp     ClickAtFirstUseCtrl

:       cmp     #'5'
        bne     :+
        jmp     ClickNeverCtrl

:       rts
.endproc

;;; ============================================================

        PAD_TO $7800
.endproc ; SelectorOverlay
