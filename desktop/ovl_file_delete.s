;;; ============================================================
;;; Overlay for File Delete
;;;
;;; Compiled as part of desktop.s
;;; ============================================================

.proc FileDeleteOverlay
        .org $7000

.proc Init
        jsr     file_dialog::OpenWindow
        jsr     DrawControls
        jsr     file_dialog::DeviceOnLine
        jsr     file_dialog::ReadDir
        jsr     file_dialog::update_scrollbar
        jsr     file_dialog::UpdateDiskName
        jsr     file_dialog::DrawListEntries
        jsr     InstallCallbackTable
        jsr     file_dialog::jt_prep_path
        jsr     file_dialog::jt_redraw_input

        copy    #$FF, LD8EC
        jmp     file_dialog::EventLoop
.endproc

.proc InstallCallbackTable
        ldx     jt_filename
:       lda     jt_filename+1,x
        sta     file_dialog::jump_table,x
        dex
        lda     jt_filename+1,x
        sta     file_dialog::jump_table,x
        dex
        dex
        bpl     :-

        lda     #0
        sta     path_buf0
        sta     file_dialog::focus_in_input2_flag

        copy    #1, path_buf2
        copy    #kGlyphInsertionPoint, path_buf2+1
        rts
.endproc

.proc DrawControls
        lda     winfo_file_dialog::window_id
        jsr     file_dialog::SetPortForWindow
        param_call file_dialog::DrawTitleCentered, aux::label_delete_file
        param_call file_dialog::DrawInput1Label, file_dialog_res::file_to_delete_label
        MGTK_RELAY_CALL MGTK::SetPenMode, penXOR
        MGTK_RELAY_CALL MGTK::FrameRect, file_dialog_res::input1_rect
        MGTK_RELAY_CALL MGTK::InitPort, main_grafport
        MGTK_RELAY_CALL MGTK::SetPort, main_grafport
        rts
.endproc

jt_filename:
        .byte file_dialog::kJumpTableSize-1
        jump_table_entry HandleOk
        jump_table_entry HandleCancel
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
        .assert * - jt_filename = file_dialog::kJumpTableSize+1, error, "Table size error"


.proc HandleOk
        param_call file_dialog::L647C, path_buf0
        beq     :+
        lda     #ERR_INVALID_PATHNAME
        jsr     JUMP_TABLE_SHOW_ALERT
        rts

:       MGTK_RELAY_CALL MGTK::CloseWindow, winfo_file_dialog_listbox
        MGTK_RELAY_CALL MGTK::CloseWindow, winfo_file_dialog
        lda     #0
        sta     LD8EC
        jsr     file_dialog::SetCursorPointer
        copy16  #path_buf0, $6
        ldx     file_dialog::stash_stack
        txs
        lda     #0
        rts
.endproc

        ;; Unused
        .byte   0

.proc HandleCancel
        MGTK_RELAY_CALL MGTK::CloseWindow, winfo_file_dialog_listbox
        MGTK_RELAY_CALL MGTK::CloseWindow, winfo_file_dialog
        lda     #0
        sta     LD8EC
        jsr     file_dialog::SetCursorPointer
        ldx     file_dialog::stash_stack
        txs
        return  #$FF
.endproc

;;; ============================================================

        PAD_TO $7800
.endproc ; FileDeleteOverlay
