;;; ============================================================
;;; DeskTop - Aux Memory Segment
;;;
;;; Compiled as part of desktop.s
;;; ============================================================

;;; ============================================================
;;; Segment loaded into AUX $4000-$BFFF
;;; ============================================================

        BEGINSEG SegmentDeskTopAux

.scope aux

        ;; Fixed location entry points
        .assert * = MGTKAuxEntry, error, "entry point"
        jmp     MGTKEntry
        .assert * = BTKAuxEntry, error, "entry point"
        jmp     btk__BTKEntry
        .assert * = LETKAuxEntry, error, "entry point"
        jmp     letk__LETKEntry

;;; ============================================================
;;; MouseGraphics ToolKit - fixed location for DAs to reference
;;; ============================================================

        MLIEntry := MLI ; TODO: this makes no sense - wrong bank!
        MGTKEntry := *
        .include "../mgtk/mgtk.s"

;;; ============================================================
;;; Default Font - fixed location for DAs to reference
;;; ============================================================

        ASSERT_ADDRESS ::DEFAULT_FONT
        .incbin .concat("../mgtk/fonts/System.", kBuildLang)

;;; ============================================================
;;; Other ToolKits - floating location (DAs have indirections)
;;; ============================================================

        ReadSetting := ReadSettingFromAux

        .include "../toolkits/icontk.s"
        ITKEntry := icon_toolkit::ITKEntry

        .include "../toolkits/letk.s"
        letk__LETKEntry := letk::LETKEntry

        .include "../toolkits/btk.s"
        btk__BTKEntry := btk::BTKEntry

;;; ============================================================
;;; Resources
;;; ============================================================


;;; ============================================================
;;; Menus

label_apple:
        PASCAL_STRING kGlyphSolidApple
label_file:
        PASCAL_STRING res_string_menu_bar_item_file    ; menu bar item
label_view:
        PASCAL_STRING res_string_menu_bar_item_view    ; menu bar item
label_special:
        PASCAL_STRING res_string_menu_bar_item_special ; menu bar item
label_startup:
        PASCAL_STRING res_string_menu_bar_item_startup ; menu bar item
label_selector:
        PASCAL_STRING res_string_menu_bar_item_selector ; menu bar item

label_new_folder:
        PASCAL_STRING res_string_menu_item_new_folder ; menu item
label_open:
        PASCAL_STRING res_string_menu_item_open ; menu item
label_close:
        PASCAL_STRING res_string_menu_item_close ; menu item
label_close_all:
        PASCAL_STRING res_string_menu_item_close_all ; menu item
label_select_all:
        PASCAL_STRING res_string_menu_item_select_all ; menu item
label_delete_selection:
        PASCAL_STRING res_string_menu_item_delete_selection ; menu item
label_eject:
        PASCAL_STRING res_string_menu_item_eject ; menu item
label_quit:
        PASCAL_STRING res_string_menu_item_quit ; menu item

label_by_icon:
        PASCAL_STRING res_string_menu_item_by_icon ; menu item
label_by_small_icon:
        PASCAL_STRING res_string_menu_item_by_small_icon ; menu item
label_by_name:
        PASCAL_STRING res_string_menu_item_by_name ; menu item
label_by_date:
        PASCAL_STRING res_string_menu_item_by_date ; menu item
label_by_size:
        PASCAL_STRING res_string_menu_item_by_size ; menu item
label_by_type:
        PASCAL_STRING res_string_menu_item_by_type ; menu item

label_check_all_drives:
        PASCAL_STRING res_string_menu_item_check_all_drives ; menu item
label_check_drive:
        PASCAL_STRING res_string_menu_item_check_drive ; menu item
label_format_disk:
        PASCAL_STRING res_string_menu_item_format_disk ; menu item
label_erase_disk:
        PASCAL_STRING res_string_menu_item_erase_disk ; menu item
label_disk_copy:
        PASCAL_STRING res_string_menu_item_disk_copy ; menu item
label_lock:
        PASCAL_STRING res_string_menu_item_lock ; menu item
label_unlock:
        PASCAL_STRING res_string_menu_item_unlock ; menu item
label_get_info:
        PASCAL_STRING res_string_menu_item_get_info ; menu item
label_rename_icon:
        PASCAL_STRING res_string_menu_item_rename_icon ; menu item
label_duplicate_icon:
        PASCAL_STRING res_string_menu_item_duplicate ; menu item
label_make_link:
        PASCAL_STRING res_string_menu_item_make_link

desktop_menu:
        DEFINE_MENU_BAR 6
@items: DEFINE_MENU_BAR_ITEM kMenuIdApple, label_apple, apple_menu
        DEFINE_MENU_BAR_ITEM kMenuIdFile, label_file, file_menu
        DEFINE_MENU_BAR_ITEM kMenuIdView, label_view, view_menu
        DEFINE_MENU_BAR_ITEM kMenuIdSpecial, label_special, special_menu
        DEFINE_MENU_BAR_ITEM kMenuIdStartup, label_startup, startup_menu
        DEFINE_MENU_BAR_ITEM kMenuIdSelector, label_selector, selector_menu
        ASSERT_RECORD_TABLE_SIZE @items, 6, .sizeof(MGTK::MenuBarItem)

file_menu:
        DEFINE_MENU kMenuSizeFile
@items: DEFINE_MENU_ITEM label_new_folder, res_char_menu_item_new_folder_shortcut
        DEFINE_MENU_ITEM label_open, res_char_menu_item_open_shortcut
        DEFINE_MENU_ITEM label_close, res_char_shortcut_close
        DEFINE_MENU_ITEM label_close_all
        DEFINE_MENU_ITEM label_select_all, res_char_menu_item_select_all_shortcut
        DEFINE_MENU_SEPARATOR
        DEFINE_MENU_ITEM label_get_info, res_char_menu_item_get_info_shortcut
        DEFINE_MENU_ITEM_NOMOD label_rename_icon, CHAR_RETURN, CHAR_RETURN
        DEFINE_MENU_ITEM label_duplicate_icon, 'D'
        DEFINE_MENU_SEPARATOR
        DEFINE_MENU_ITEM label_copy_selection
        DEFINE_MENU_ITEM label_delete_selection, $7F
        DEFINE_MENU_SEPARATOR
        DEFINE_MENU_ITEM label_quit, res_char_menu_item_quit_shortcut
        ASSERT_RECORD_TABLE_SIZE @items, ::kMenuSizeFile, .sizeof(MGTK::MenuItem)

        kMenuItemIdNewFolder   = 1
        kMenuItemIdOpen        = 2
        kMenuItemIdClose       = 3
        kMenuItemIdCloseAll    = 4
        kMenuItemIdSelectAll   = 5
        ;; --------------------
        kMenuItemIdGetInfo     = 7
        kMenuItemIdRenameIcon  = 8
        kMenuItemIdDuplicate   = 9
        ;; --------------------
        kMenuItemIdCopyFile    = 11
        kMenuItemIdDeleteFile  = 12
        ;; --------------------
        kMenuItemIdQuit        = 14

view_menu:
        DEFINE_MENU kMenuSizeView
@items: DEFINE_MENU_ITEM label_by_icon
        DEFINE_MENU_ITEM label_by_small_icon
        DEFINE_MENU_ITEM label_by_name
        DEFINE_MENU_ITEM label_by_date
        DEFINE_MENU_ITEM label_by_size
        DEFINE_MENU_ITEM label_by_type
        ASSERT_RECORD_TABLE_SIZE @items, ::kMenuSizeView, .sizeof(MGTK::MenuItem)

        kMenuItemIdViewByIcon      = 1
        kMenuItemIdViewBySmallIcon = 2
        kMenuItemIdViewByName      = 3
        kMenuItemIdViewByDate      = 4
        kMenuItemIdViewBySize      = 5
        kMenuItemIdViewByType      = 6

special_menu:
        DEFINE_MENU kMenuSizeSpecial
@items: DEFINE_MENU_ITEM label_check_all_drives
        DEFINE_MENU_ITEM label_check_drive
        DEFINE_MENU_ITEM label_eject, res_char_menu_item_eject_shortcut
        DEFINE_MENU_SEPARATOR
        DEFINE_MENU_ITEM label_format_disk
        DEFINE_MENU_ITEM label_erase_disk
        DEFINE_MENU_ITEM label_disk_copy
        DEFINE_MENU_SEPARATOR
        DEFINE_MENU_ITEM label_lock
        DEFINE_MENU_ITEM label_unlock
        DEFINE_MENU_ITEM label_make_link
        ASSERT_RECORD_TABLE_SIZE @items, ::kMenuSizeSpecial, .sizeof(MGTK::MenuItem)

        kMenuItemIdCheckAll    = 1
        kMenuItemIdCheckDrive  = 2
        kMenuItemIdEject       = 3
        ;; --------------------
        kMenuItemIdFormatDisk  = 5
        kMenuItemIdEraseDisk   = 6
        kMenuItemIdDiskCopy    = 7
        ;; --------------------
        kMenuItemIdLock        = 9
        kMenuItemIdUnlock      = 10
        kMenuItemIdMakeLink    = 11

;;; ============================================================

kDialogLabelHeight      = kSystemFontHeight+1
kDialogTitleY           = 17
kDialogLabelBaseY       = 23
kDialogLabelRow1        = kDialogLabelBaseY + kDialogLabelHeight * 1
kDialogLabelRow2        = kDialogLabelBaseY + kDialogLabelHeight * 2
kDialogLabelRow3        = kDialogLabelBaseY + kDialogLabelHeight * 3
kDialogLabelRow4        = kDialogLabelBaseY + kDialogLabelHeight * 4
kDialogLabelRow5        = kDialogLabelBaseY + kDialogLabelHeight * 5
kDialogLabelRow6        = kDialogLabelBaseY + kDialogLabelHeight * 6

;;; ============================================================
;;; Prompt dialog resources

        DEFINE_RECT_FRAME prompt_dialog_frame_rect, kPromptDialogWidth, kPromptDialogHeight

        kPromptDialogInsetLeft   = 8
        kPromptDialogInsetTop    = 20
        kPromptDialogInsetRight  = 8
        kPromptDialogInsetBottom = 20
        DEFINE_RECT clear_dialog_labels_rect, kPromptDialogInsetLeft, kPromptDialogInsetTop, kPromptDialogWidth-kPromptDialogInsetRight, kPromptDialogHeight-kPromptDialogInsetBottom

        DEFINE_RECT prompt_rect, 40, kDialogLabelRow5+1, 360, kDialogLabelRow6

;;; ============================================================
;;; Progress dialog resources

        kProgressDialogWidth = 400
        kProgressDialogHeight = 46

        kProgressDialogLabelRow0        = kProgressDialogLabelBaseY + aux::kDialogLabelHeight * 0
        kProgressDialogLabelRow1        = kProgressDialogLabelBaseY + aux::kDialogLabelHeight * 1
        kProgressDialogLabelRow2        = kProgressDialogLabelBaseY + aux::kDialogLabelHeight * 2

        DEFINE_RECT_FRAME progress_dialog_frame_rect, kProgressDialogWidth, kProgressDialogHeight

        DEFINE_POINT current_target_file_pos, kProgressDialogPathLeft, kProgressDialogLabelRow1
        DEFINE_POINT current_dest_file_pos, kProgressDialogPathLeft, kProgressDialogLabelRow2
        DEFINE_RECT current_target_file_rect, kProgressDialogPathLeft, kProgressDialogLabelRow0+1, kProgressDialogPathLeft + kProgressDialogPathWidth, kProgressDialogLabelRow1
        DEFINE_RECT current_dest_file_rect, kProgressDialogPathLeft, kProgressDialogLabelRow1+1, kProgressDialogPathLeft + kProgressDialogPathWidth, kProgressDialogLabelRow2


;;; ============================================================
;;; "About" dialog resources

kAboutDialogWidth       = 400
kAboutDialogHeight      = 120

        DEFINE_RECT_FRAME about_dialog_frame_rect, kAboutDialogWidth, kAboutDialogHeight

str_about1:  PASCAL_STRING kDeskTopProductName
str_about2:  PASCAL_STRING res_string_copyright_line1
str_about3:  PASCAL_STRING res_string_copyright_line2
str_about4:  PASCAL_STRING res_string_copyright_line3
str_about5:  PASCAL_STRING res_string_about_text_line5
str_about6:  PASCAL_STRING res_string_about_text_line6
str_about7:  PASCAL_STRING res_string_about_text_line7
str_about8:  PASCAL_STRING kBuildDate
str_about9:  PASCAL_STRING .sprintf(res_string_noprod_version_format_long,::kDeskTopVersionMajor,::kDeskTopVersionMinor,kDeskTopVersionSuffix)

str_files_remaining:
        PASCAL_STRING res_string_label_files_remaining

        ;; "Copy File" dialog strings
str_copy_copying:
        PASCAL_STRING res_string_copy_label_status
str_copy_from:
        PASCAL_STRING res_string_copy_label_from
str_copy_to:
        PASCAL_STRING res_string_copy_label_to

        ;; "Move File" dialog strings
str_move_moving:
        PASCAL_STRING res_string_move_label_status

str_exists_prompt:
        PASCAL_STRING res_string_prompt_overwrite
str_large_copy_prompt:
        PASCAL_STRING res_string_errmsg_too_large_to_copy
str_large_move_prompt:
        PASCAL_STRING res_string_errmsg_too_large_to_move

        ;; "Delete" dialog strings
str_delete_confirm_prefix:
        PASCAL_STRING res_string_prompt_delete_confirm_prefix
str_delete_confirm_suffix:
        PASCAL_STRING res_string_prompt_delete_confirm_suffix
str_delete_count:
        PASCAL_STRING res_string_label_delete_count
str_file_colon:
        PASCAL_STRING res_string_label_file
str_delete_locked_file:
        PASCAL_STRING res_string_delete_prompt_locked_file

        ;; "New Folder" dialog strings
str_in:
        PASCAL_STRING res_string_new_folder_label_in
str_enter_folder_name:
        PASCAL_STRING res_string_new_folder_label_name

        ;; "Rename Icon" dialog strings
str_rename_old:
        PASCAL_STRING res_string_rename_label_old
str_rename_new:
        PASCAL_STRING res_string_rename_label_new

        ;; "Duplicate" dialog strings
str_duplicate_original:
        PASCAL_STRING res_string_rename_label_original

        ;; "Get Info" dialog strings
str_info_name:
        PASCAL_STRING res_string_get_info_label_name
str_info_locked:
        PASCAL_STRING res_string_get_info_label_locked
str_info_file_size:
        PASCAL_STRING res_string_get_info_label_file_size
str_info_create:
        PASCAL_STRING res_string_get_info_label_create
str_info_mod:
        PASCAL_STRING res_string_get_info_label_mod
str_info_type:
        PASCAL_STRING res_string_get_info_label_type
str_info_protected:
        PASCAL_STRING res_string_get_info_label_protected
str_info_vol_size:
        PASCAL_STRING res_string_get_info_label_vol_size
str_info_yes:
        PASCAL_STRING res_string_get_info_label_yes
str_info_no:
        PASCAL_STRING res_string_get_info_label_no
str_info_size_infix:
        PASCAL_STRING res_string_get_info_label_size_infix
str_info_size_suffix:
        PASCAL_STRING res_string_get_info_label_size_suffix
str_info_size_suffix_singular:
        PASCAL_STRING res_string_get_info_label_size_suffix_singular
str_info_size_slash:
        PASCAL_STRING res_string_get_info_label_size_slash

str_select_format:
        PASCAL_STRING res_string_format_disk_label_select
str_location:
        PASCAL_STRING res_string_format_disk_label_location
str_new_volume:
        PASCAL_STRING res_string_format_disk_label_enter_name
str_formatting:
        PASCAL_STRING res_string_format_disk_status_formatting
str_formatting_error:
        PASCAL_STRING res_string_format_disk_error

str_select_erase:
        PASCAL_STRING res_string_erase_disk_label_select
str_confirm_erase_prefix:
        PASCAL_STRING res_string_erase_disk_prompt_erase_prefix
str_confirm_erase_suffix:
        PASCAL_STRING res_string_erase_disk_prompt_erase_suffix
str_erasing:
        PASCAL_STRING res_string_erase_disk_status_erasing
str_erasing_error:
        PASCAL_STRING res_string_erase_disk_error

        ;; "Unlock File" dialog strings
str_unlock_count:
        PASCAL_STRING res_string_unlock_status_count

        ;; "Lock File" dialog strings
str_lock_count:
        PASCAL_STRING res_string_lock_status_count

;;; Miscellaneous alert strings

str_ramcard_full:
        PASCAL_STRING res_string_download_error_ramcard_full
str_warning_selector_list_full:
        PASCAL_STRING res_string_warning_selector_list_full
;;; The same string is used for both of these cases as the second case
;;; (a single directory with too many items) is very difficult to hit.
str_warning_too_many_files:     ; alt: `res_string_warning_too_many_files`
str_warning_window_must_be_closed:
        PASCAL_STRING res_string_warning_window_must_be_closed
str_warning_too_many_windows:
        PASCAL_STRING res_string_warning_too_many_windows
str_alert_confirm_running:
        PASCAL_STRING res_string_alert_confirm_running
str_alert_bad_replacement:
        PASCAL_STRING res_string_alert_bad_replacement
str_alert_unsupported_type:
        PASCAL_STRING res_string_alert_unsupported_type
str_alert_move_copy_into_self:
        PASCAL_STRING res_string_alert_move_copy_into_self
str_alert_cannot_open:
        PASCAL_STRING res_string_alert_cannot_open
str_alert_name_too_long:
        PASCAL_STRING res_string_alert_name_too_long
str_alert_insert_source_disk:
        PASCAL_STRING res_string_alert_insert_source_disk
str_alert_insert_destination:
        PASCAL_STRING res_string_alert_insert_destination
str_alert_unreadable_format:
        PASCAL_STRING res_string_alert_unreadable_format

;;; ============================================================
;;; Show Alert Dialog
;;; Call show_alert_dialog with prompt number A, options in X
;;; Options:
;;;    0 = use defaults for alert number; otherwise, look at top 2 bits
;;;  %0....... e.g. $01 = OK
;;;  %10...... e.g. $80 = Try Again, Cancel
;;;  %11...... e.g. $C0 = OK, Cancel
;;; Return value:
;;;   0 = Try Again
;;;   1 = Cancel
;;;   2 = OK

.proc AlertById
        jmp     start

;;; --------------------------------------------------
;;; Messages

err_unknown:                    ; kErrUnknown
        PASCAL_STRING res_string_errmsg_00

err_27:  PASCAL_STRING res_string_errmsg_27
err_28:  PASCAL_STRING res_string_errmsg_28
err_2B:  PASCAL_STRING res_string_errmsg_2B
err_40:  PASCAL_STRING res_string_errmsg_40
err_44:  PASCAL_STRING res_string_errmsg_44
err_45:  PASCAL_STRING res_string_errmsg_45
err_46:  PASCAL_STRING res_string_errmsg_46
err_47:  PASCAL_STRING res_string_errmsg_47
err_48:  PASCAL_STRING res_string_errmsg_48
err_49:  PASCAL_STRING res_string_errmsg_49
err_4E:  PASCAL_STRING res_string_errmsg_4E
err_52:  PASCAL_STRING res_string_errmsg_52
err_57:  PASCAL_STRING res_string_errmsg_57

;;; Below are internal (not ProDOS MLI) error codes.
err_insert_system_disk:         ; kErrInsertSystemDisk
        PASCAL_STRING res_string_warning_insert_system_disk
err_save_changes:               ; kErrSaveChanges
        PASCAL_STRING res_string_warning_save_changes
err_no_windows:                 ; kErrNoWindowsOpen
        PASCAL_STRING res_string_alert_no_windows_open
err_duplicate_volumes:          ; kErrDuplicateVolName
        PASCAL_STRING res_string_alert_duplicate_volume_names
err_no_basic_system:            ; kErrBasicSysNotFound
        PASCAL_STRING res_string_alert_basic_system_not_found

        ;; number of alert messages
        kNumAlerts = 19

        ;; message number-to-index table
        ;; (look up by scan to determine index)
alert_table:
        .byte   kErrUnknown

        ;; ProDOS MLI error codes:
        .byte   ERR_IO_ERROR, ERR_DEVICE_NOT_CONNECTED, ERR_WRITE_PROTECTED
        .byte   ERR_INVALID_PATHNAME, ERR_PATH_NOT_FOUND, ERR_VOL_NOT_FOUND
        .byte   ERR_FILE_NOT_FOUND, ERR_DUPLICATE_FILENAME, ERR_OVERRUN_ERROR
        .byte   ERR_VOLUME_DIR_FULL, ERR_ACCESS_ERROR, ERR_NOT_PRODOS_VOLUME
        .byte   ERR_DUPLICATE_VOLUME

        ;; Internal error codes:
        .byte   kErrInsertSystemDisk
        .byte   kErrSaveChanges
        .byte   kErrNoWindowsOpen
        .byte   kErrDuplicateVolName
        .byte   kErrBasicSysNotFound
        ASSERT_TABLE_SIZE alert_table, kNumAlerts

        ;; alert index to string address
message_table_low:
        .byte   <err_unknown
        .byte   <err_27,<err_28,<err_2B,<err_40,<err_44,<err_45,<err_46
        .byte   <err_47,<err_48,<err_49,<err_4E,<err_52,<err_57
        .byte   <err_insert_system_disk
        .byte   <err_save_changes
        .byte   <err_no_windows
        .byte   <err_duplicate_volumes
        .byte   <err_no_basic_system
        ASSERT_TABLE_SIZE message_table_low, kNumAlerts

message_table_high:
        .byte   >err_unknown
        .byte   >err_27,>err_28,>err_2B,>err_40,>err_44,>err_45,>err_46
        .byte   >err_47,>err_48,>err_49,>err_4E,>err_52,>err_57
        .byte   >err_insert_system_disk
        .byte   >err_save_changes
        .byte   >err_no_windows
        .byte   >err_duplicate_volumes
        .byte   >err_no_basic_system
        ASSERT_TABLE_SIZE message_table_high, kNumAlerts

alert_options_table:
        .byte   AlertButtonOptions::OK             ; kErrUnknown
        .byte   AlertButtonOptions::OK             ; ERR_IO_ERROR
        .byte   AlertButtonOptions::OK             ; ERR_DEVICE_NOT_CONNECTED
        .byte   AlertButtonOptions::TryAgainCancel ; ERR_WRITE_PROTECTED
        .byte   AlertButtonOptions::OK             ; ERR_INVALID_PATHNAME
        .byte   AlertButtonOptions::TryAgainCancel ; ERR_PATH_NOT_FOUND
        .byte   AlertButtonOptions::OK             ; ERR_VOL_NOT_FOUND
        .byte   AlertButtonOptions::OK             ; ERR_FILE_NOT_FOUND
        .byte   AlertButtonOptions::OK             ; ERR_DUPLICATE_FILENAME
        .byte   AlertButtonOptions::OK             ; ERR_OVERRUN_ERROR
        .byte   AlertButtonOptions::OK             ; ERR_VOLUME_DIR_FULL
        .byte   AlertButtonOptions::OK             ; ERR_ACCESS_ERROR
        .byte   AlertButtonOptions::OK             ; ERR_NOT_PRODOS_VOLUME
        .byte   AlertButtonOptions::OK             ; ERR_DUPLICATE_VOLUME

        .byte   AlertButtonOptions::OKCancel       ; kErrInsertSystemDisk
        .byte   AlertButtonOptions::OKCancel       ; kErrSaveChanges
        .byte   AlertButtonOptions::OK             ; kErrNoWindowsOpen
        .byte   AlertButtonOptions::OK             ; kErrDuplicateVolName
        .byte   AlertButtonOptions::OK             ; kErrBasicSysNotFound
        ASSERT_TABLE_SIZE alert_options_table, kNumAlerts

start:
        ;; --------------------------------------------------
        ;; Process options, populate `alert_params`

        ;; A = alert, X = options

        ;; Search for alert in table, set Y to index
        ldy     #kNumAlerts-1
:       cmp     alert_table,y
        beq     :+
        dey
        bpl     :-
        iny                     ; default
:

        ;; Look up message
        copylohi  message_table_low,y, message_table_high,y, alert_params+AlertParams::text

        ;; If options is 0, use table value; otherwise,
        ;; mask off low bit and it's the action (N and V bits)

        ;; %00000000 = Use default options
        ;; %0....... e.g. $01 = OK
        ;; %10...... e.g. $80 = Try Again, Cancel
        ;; %11...... e.g. $C0 = OK, Cancel

        cpx     #0
      IF_NE
        txa
        and     #$FE            ; ignore low bit, e.g. treat $01 as $00
        sta     alert_params+AlertParams::buttons
      ELSE
        copy    alert_options_table,y, alert_params+AlertParams::buttons
      END_IF
        copy    #AlertOptions::Beep|AlertOptions::SaveBack, alert_params+AlertParams::options

        ldax    #alert_params
        FALL_THROUGH_TO Alert
.endproc ; AlertById

;;; ============================================================
;;; Display alert
;;; Inputs: A,X=alert_params structure
;;;    { .addr text, .byte AlertButtonOptions, .byte AlertOptions }

        SystemTask = SystemTaskFromAux
        alert_grafport = desktop_grafport

        AD_SAVEBG = 1
        AD_YESNOALL = 1
        Bell := BellFromAux
        BTKEntry := BTKAuxEntry
        .include "../lib/alert_dialog.s"
        .include "../lib/drawstring.s"

;;; ============================================================

.proc FlipMGTKHiresTable
        ldy     #0
        ldx     #kScreenHeight-1

:       lda     mgtk::hires_table_lo,x
        pha
        lda     mgtk::hires_table_lo,y
        sta     mgtk::hires_table_lo,x
        pla
        sta     mgtk::hires_table_lo,y

        lda     mgtk::hires_table_hi,x
        pha
        lda     mgtk::hires_table_hi,y
        sta     mgtk::hires_table_hi,x
        pla
        sta     mgtk::hires_table_hi,y

        dex
        iny
        cpy     #kScreenHeight/2
        bne     :-

        rts
.endproc ; FlipMGTKHiresTable

;;; ============================================================

.endscope ; aux

        ENDSEG SegmentDeskTopAux
