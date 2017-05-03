meta:
  id: psd
  file-extension: psd
  endian: be
  encoding: UTF-16BE
seq:
  - id: header
    type: header
  - id: color_mode_data
    type: color_mode_data
  - id: image_resources
    type: image_resources
  - id: layer_and_mask_information
    type: layer_and_mask_information
#  - id: image_data
#    type: image_data
types:
  header:
    seq:
      - id: signature
        contents: [0x38, 0x42, 0x50, 0x53] #8BIM
      - id: version
        contents: [0x00, 0x01]
      - id: reserved_field
        contents: [0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
      - id: number_of_channels
        type: s2
        doc: value must be in range 1 to 56
      - id: dimensions
        type: dimensions
      - id: depth
        type: s2
        doc: number of bits per channel, either 1, 8, 16 or 32
      - id: color_mode
        type: s2
        enum: color_mode
    types:
      dimensions:
       seq:
          - id: height
            type: s4
            doc: measured in number of pixels, value must be in range 1 to 30000
          - id: width
            type: s4
            doc: measured in number of pixels, value must be in range 1 to 30000
  color_mode_data:
    seq:
      - id: size_of_data
        type: s4
        doc: for indexed color mode this size is 768, for duotone color mode this size is variable
      - id: data
        size: size_of_data
        if: _parent.header.color_mode == color_mode::indexed or _parent.header.color_mode == color_mode::duotone
        doc: this data is only provided if the color mode is either indexed or duotone
  image_resources:
    seq:
      - id: size_of_data
        type: s4
      - id: data
        type: image_resource_blocks
        size: size_of_data
    types:
      image_resource_blocks:
        seq:
          - id: resources
            type: image_resource_block
            repeat: eos
        types:
          image_resource_block:
            seq:
              - id: signature
                contents: [0x38, 0x42, 0x49, 0x4d] #8BIM
              - id: unique_identifier
                type: s2
                enum: image_resource_identifier
              - id: name
                type: pascal_string_padded_to_2_byte_multiple
              - id: resource_data_size
                type: s4
              - id: resource_data
                size: resource_data_size
                type:
                  switch-on: unique_identifier
                  cases:
                    image_resource_identifier::photoshop_2_0_values: photoshop_2_0_values_resource
                    #image_resource_identifier::macintosh_print_manager_print_info_record: macintosh_print_manager_print_info_record
                    #image_resource_identifier::macintosh_page_format_information: macintosh_page_format_information
                    #image_resource_identifier::indexed_color_table: indexed_color_table
                    image_resource_identifier::resolution_info: resolution_info_resource
                    image_resource_identifier::alpha_channel_names: alpha_channel_names_resource
                    #image_resource_identifier::obsolete_1007: obsolete_1007
                    image_resource_identifier::caption: pascal_string_padded_to_2_byte_multiple
                    image_resource_identifier::border_information: border_information_resource
                    image_resource_identifier::background_color: color_resource
                    image_resource_identifier::print_flags: print_flags_resource
                    #image_resource_identifier::grayscale_multichannel_halftoning_information: grayscale_multichannel_halftoning_information
                    #image_resource_identifier::color_halftoning_information: color_halftoning_information
                    #image_resource_identifier::duotone_halftoning_information: duotone_halftoning_information
                    #image_resource_identifier::grayscale_multichannel_transfer_function: grayscale_multichannel_transfer_function
                    #image_resource_identifier::color_transfer_functions: color_transfer_functions
                    #image_resource_identifier::duotone_transfer_functions: duotone_transfer_functions
                    #image_resource_identifier::duotone_image_information: duotone_image_information
                    #image_resource_identifier::effective_black_white_values_for_dot_range: effective_black_white_values_for_dot_range
                    #image_resource_identifier::obsolete_1020: obsolete_1020
                    #image_resource_identifier::eps_options: eps_options
                    image_resource_identifier::quick_mask_information: quick_mask_information_resource
                    #image_resource_identifier::obsolete_1023: obsolete_1023
                    image_resource_identifier::layer_state_information: layer_state_information_resource
                    image_resource_identifier::working_path: path_resource
                    image_resource_identifier::layers_group_information: layers_group_information_resource
                    #image_resource_identifier::obsolete_1027: obsolete_1027
                    #image_resource_identifier::iptc_naa_record: iptc_naa_record
                    #image_resource_identifier::image_mode_for_raw_format_files: image_mode_for_raw_format_files
                    #image_resource_identifier::jpeg_quality: jpeg_quality
                    image_resource_identifier::grid_guides_information: grid_guides_information_resource
                    image_resource_identifier::thumbnail_resource_for_photoshop_4: thumbnail_resource
                    #image_resource_identifier::copyright_flag: copyright_flag
                    #image_resource_identifier::url: url
                    image_resource_identifier::thumbnail_resource: thumbnail_resource
                    image_resource_identifier::global_angle: global_angle_resource
                    image_resource_identifier::color_samplers_resource: color_samplers_resource
                    #image_resource_identifier::icc_profile: icc_profile
                    image_resource_identifier::watermark: watermark_resource
                    image_resource_identifier::icc_untagged_profile: icc_untagged_profile_resource
                    image_resource_identifier::effects_visible: effects_visible_resource
                    image_resource_identifier::spot_halftone: spot_halftone_resource
                    image_resource_identifier::document_specific_ids_seed_number: document_specific_ids_seed_number_resource
                    image_resource_identifier::unicode_alpha_names: unicode_string_resource
                    image_resource_identifier::indexed_color_table_count: indexed_color_table_count_resource
                    image_resource_identifier::transparency_index: transparency_index_resource
                    image_resource_identifier::global_altitude: global_altitude_resource
                    image_resource_identifier::slices: slices_resource
                    image_resource_identifier::workflow_url: unicode_string_resource
                    image_resource_identifier::jump_to_xpep: jump_to_xpep_resource
                    image_resource_identifier::alpha_identifiers: alpha_identifiers_resource
                    image_resource_identifier::url_list: url_list_resource
                    image_resource_identifier::version_info: version_info_resource
                    #image_resource_identifier::exif_data_1: exif_data_1
                    #image_resource_identifier::exif_data_3: exif_data_3
                    #image_resource_identifier::xmp_metadata: xmp_metadata
                    image_resource_identifier::caption_digest: caption_digest_resource
                    image_resource_identifier::print_scale: print_scale_resource
                    image_resource_identifier::pixel_aspect_ratio: pixel_aspect_ratio_resource
                    image_resource_identifier::layer_comps: descriptor_resource_with_version
                    image_resource_identifier::alternate_duotone_colors: alternate_duotone_colors_resource
                    image_resource_identifier::alternate_spot_colors: alternate_spot_colors_resource
                    image_resource_identifier::layer_selection_ids: layer_selection_ids_resource
                    #image_resource_identifier::hdr_toning_information: hdr_toning_information
                    #image_resource_identifier::print_info: print_info
                    image_resource_identifier::layer_groups_enabled_id: layer_groups_enabled_id_resource
                    image_resource_identifier::color_samplers_resource: color_samplers_resource
                    image_resource_identifier::measurement_scale: descriptor_resource_with_version
                    image_resource_identifier::timeline_information: descriptor_resource_with_version
                    image_resource_identifier::sheet_disclosure: descriptor_resource_with_version
                    #image_resource_identifier::displayinfo_structure_for_floating_point_colors: displayinfo_structure_for_floating_point_colors
                    image_resource_identifier::onion_skins: descriptor_resource_with_version
                    image_resource_identifier::count_information: descriptor_resource_with_version
                    image_resource_identifier::print_information: descriptor_resource_with_version
                    image_resource_identifier::print_style: descriptor_resource_with_version
                    #image_resource_identifier::macintosh_nsprintinfo: macintosh_nsprintinfo
                    #image_resource_identifier::windows_devmode: windows_devmode
                    image_resource_identifier::auto_save_file_path: unicode_string_resource
                    image_resource_identifier::auto_save_format: unicode_string_resource
                    image_resource_identifier::path_selection_state: descriptor_resource_with_version
                    #image_resource_identifier::name_of_clipping_path: name_of_clipping_path
                    #image_resource_identifier::origin_path_info: origin_path_info
                    #image_resource_identifier::image_ready_variables: image_ready_variables
                    #image_resource_identifier::image_ready_data_sets: image_ready_data_sets
                    #image_resource_identifier::image_ready_default_selected_state: image_ready_default_selected_state
                    #image_resource_identifier::image_ready_7_rollover_expanded_state: image_ready_7_rollover_expanded_state
                    #image_resource_identifier::image_ready_rollover_expanded_state: image_ready_rollover_expanded_state
                    #image_resource_identifier::image_ready_save_layer_settings: image_ready_save_layer_settings
                    #image_resource_identifier::image_ready_version: image_ready_version
                    #image_resource_identifier::lightroom_workflow: lightroom_workflow
                    image_resource_identifier::print_flags_information: print_flags_information_resource
                if: resource_is_normal == true
              - id: resource_data
                size: resource_data_size
                type: path_resource
                if: resource_is_saved_path == true
              - id: resource_data
                size: resource_data_size
                if: resource_is_plug_in == true
              - id: padding
                size: 1
                if: (name.length + resource_data_size) % 2 == 1
            instances:
              resource_is_saved_path:
                value: >
                  unique_identifier.to_i >= image_resource_identifier::path_information_saved_path_first.to_i
                  and
                  unique_identifier.to_i <= image_resource_identifier::path_information_saved_path_last.to_i
              resource_is_plug_in:
                value: >
                  unique_identifier.to_i >= image_resource_identifier::plug_in_resources_first.to_i
                  and
                  unique_identifier.to_i <= image_resource_identifier::plug_in_resources_last.to_i
              resource_is_normal:
                value: not (resource_is_saved_path or resource_is_plug_in)
            types:
              photoshop_2_0_values_resource:
                seq:
                  - id: number_of_channels
                    type: s2
                  - id: number_of_rows
                    type: s2
                  - id: depth
                    type: s2
                  - id: mode
                    type: s2
              resolution_info_resource:
                seq:
                  - id: horizontal_resolution
                    type: resolution_definition
                  - id: width_unit
                    type: s2
                    enum: width_height_units
                  - id: vertical_resolution
                    type: resolution_definition
                  - id: height_unit
                    type: s2
                    enum: width_height_units
                types:
                  resolution_definition:
                    seq:
                      - id: resolution
                        size: 4
                      - id: display_unit
                        type: s2
                        enum: display_units
                    enums:
                      display_units:
                        0: pixels_per_inch
                        1: pixels_per_cm
                enums:
                  width_height_units:
                    1: inches
                    2: cm
                    3: points
                    4: picas
                    5: columns
              alpha_channel_names_resource:
                seq:
                  - id: names
                    type: pascal_string_padded_to_2_byte_multiple
                    repeat: eos
              border_information_resource:
                seq:
                  - id: width
                    type: f4
                  - id: units
                    type: s2
                    enum: border_units
                enums:
                  border_units:
                    1: inches
                    2: cm
                    3: points
                    4: picas
                    5: columns
              color_resource:
                seq:
                  - id: color_space
                    type: s2
                    enum: color_spaces
                  - id: color_values
                    type: s2
                    repeat: expr
                    repeat-expr: 4
                enums:
                  color_spaces:
                    0: rgb
                    1: hsb
                    2: cmyk
                    3: pantone_matching_system
                    4: focoltone_colour_system
                    5: trumatch_color
                    6: toyo_88_colorfinder_1050
                    7: lab
                    8: grayscale
                    10: hks_colors
              print_flags_resource:
                seq:
                  - id: labels
                    type: b8
                  - id: crop_marks
                    type: b8
                  - id: color_bars
                    type: b8
                  - id: registration_marks
                    type: b8
                  - id: negative
                    type: b8
                  - id: flip
                    type: b8
                  - id: interpolate
                    type: b8
                  - id: caption
                    type: b8
                  - id: print_flags
                    type: b8
              quick_mask_information_resource:
                seq:
                  - id: quick_mask_channel_id
                    size: 2
                  - id: mask_initially_empty
                    type: b8
              layer_state_information_resource:
                seq:
                  - id: index_of_target_layer
                    type: s2
                    doc: a value of 0 equates to the bottom layer
              path_resource:
                seq:
                  - id: path_records
                    type: path_record
                    size: 26
                    repeat: eos
                types:
                  path_record:
                    seq:
                      - id: path_type
                        type: s2
                        enum: type_of_paths
                      - id: path_data
                        type:
                          switch-on: path_type
                          cases:
                            type_of_paths::closed_subpath_length_record: subpath_length_record_data
                            type_of_paths::closed_subpath_bezier_knot_linked: bezier_knot_record_data
                            type_of_paths::closed_subpath_bezier_knot_unlinked: bezier_knot_record_data
                            type_of_paths::open_subpath_length_record: subpath_length_record_data
                            type_of_paths::open_subpath_bezier_knot_linked: bezier_knot_record_data
                            type_of_paths::open_subpath_bezier_knot_unlinked: bezier_knot_record_data
                            type_of_paths::path_fill_rule_record: path_fill_rule_record_data
                            type_of_paths::clipboard_record: clipboard_record_data
                            type_of_paths::initial_fill_rule_record: initial_fill_rule_record_data
                    types:
                      path_fill_rule_record_data:
                        seq:
                          - id: padding
                            size: 24
                            doc: each byte must have a value of 0x00
                      subpath_length_record_data:
                        seq:
                          - id: number_of_bezier_knot_records
                            type: s2
                          - id: padding
                            size: 22
                      bezier_knot_record_data:
                        seq:
                          - id: preceding_path_control_point
                            type: path_point
                          - id: anchor_point
                            type: path_point
                          - id: leaving_path_control_point
                            type: path_point
                        types:
                          path_point:
                            seq:
                              - id: vertical_component
                                size: 4
                              - id: horizontal_component
                                size: 4
                      clipboard_record_data:
                        seq:
                          - id: top
                            size: 4
                          - id: left
                            size: 4
                          - id: bottom
                            size: 4
                          - id: right
                            size: 4
                          - id: resolution
                            size: 4
                          - id: padding
                            size-eos: true
                      initial_fill_rule_record_data:
                        seq:
                          - id: record
                            type: s2
                            enum: record_values
                          - id: padding
                            size-eos: true
                        enums:
                          record_values:
                            0: fill_does_not_start_with_all_pixels
                            1: fill_starts_with_all_pixels
                    enums:
                      type_of_paths:
                        0: closed_subpath_length_record
                        1: closed_subpath_bezier_knot_linked
                        2: closed_subpath_bezier_knot_unlinked
                        3: open_subpath_length_record
                        4: open_subpath_bezier_knot_linked
                        5: open_subpath_bezier_knot_unlinked
                        6: path_fill_rule_record
                        7: clipboard_record
                        8: initial_fill_rule_record
              layers_group_information_resource:
                seq:
                  - id: layer_groups
                    type: s2
                    repeat: eos
              grid_guides_information_resource:
                seq:
                  - id: header
                    type: grid_guide_header
                  - id: guide_resource_blocks
                    type: guide_resource_block
                    repeat: expr
                    repeat-expr: header.number_of_guide_resource_blocks
                types:
                  grid_guide_header:
                    seq:
                      - id: version
                        contents: [0x00, 0x00, 0x00, 0x01] #version = 1
                      - id: future_implementation_of_document_specific_grids
                        size: 8
                      - id: number_of_guide_resource_blocks
                        type: s4
                  guide_resource_block:
                    seq:
                      - id: location_of_guide_in_document_coordinates
                        size: 4
                      - id: direction_of_guide
                        type: u1
                        enum: guide_directions
                    enums:
                      guide_directions:
                        0: vertical
                        1: horizontal
              thumbnail_resource:
                seq:
                  - id: format
                    type: s4
                    enum: thumbnail_formats
                  - id: width
                    type: s4
                    doc: value measured in number of pixels
                  - id: height
                    type: s4
                    doc: value measured in number of pixels
                  - id: width_bytes
                    type: s4
                    doc: value should be equal to (width * bits_per_pixel + 31) / 32 * 4
                  - id: total_size
                    type: s4
                    doc: value should be equal to width_bytes * height * number_of_planes
                  - id: size_after_compression
                    type: s4
                  - id: bits_per_pixel
                    type: s2
                    doc: should be equal to 24
                  - id: number_of_planes
                    type: s2
                    doc: should be equal to 1
                  - id: jfif_compressed_data
                    size: size_after_compression
                enums:
                  thumbnail_formats:
                    0: raw_rgb
                    1: jpeg_rgb
              global_angle_resource:
                seq:
                  - id: global_lighting_angle_for_effects_layer
                    type: s4
                    doc: value should be between 0 and 359 degrees
              color_samplers_resource:
                seq:
                  - id: header
                    type: color_samplers_header
                  - id: color_samplers_blocks
                    type: color_samplers_block
                    repeat: expr
                    repeat-expr: header.number_of_color_samplers
                types:
                  color_samplers_header:
                    seq:
                      - id: version
                        type: s4
                        doc: value should be 1, 2 or 3
                      - id: number_of_color_samplers
                        type: s4
                  color_samplers_block:
                    seq:
                      - id: version_of_color_samplers
                        type: s4
                        if: _parent.header.version == 3
                        doc: value should be 1
                      - id: horizontal_position_of_the_point
                        size: 4
                        doc: type is a fixed value for version 1, float value for version 2
                      - id: vertical_position_of_the_point
                        size: 4
                      - id: color_space
                        type: s2
                        enum: color_spaces
                      - id: depth
                        type: s2
                        if: _parent.header.version == 2
              watermark_resource:
                seq:
                  - id: watermark
                    size: 1
              icc_untagged_profile_resource:
                seq:
                  - id: profile_handling
                    type: u1
                    enum: profile_handling_approaches
                enums:
                  profile_handling_approaches:
                    0: assumed_profile_handling
                    1: intentionally_untagged
              effects_visible_resource:
                seq:
                  - id: effects_layer_visibility
                    type: u1
                    doc: global flag to show or hide all the effects layers
              spot_halftone_resource:
                seq:
                  - id: version
                    type: s4
                  - id: length
                    type: s4
                  - id: data
                    size: length
              document_specific_ids_seed_number_resource:
                seq:
                  - id: seed_number
                    type: s4
              indexed_color_table_count_resource:
                seq:
                  - id: number_of_colors_in_table_actually_defined
                    type: s2
              transparency_index_resource:
                seq:
                  - id: index_of_transparent_color
                    type: s2
              global_altitude_resource:
                seq:
                  - id: global_altitude
                    type: s4
              slices_resource:
                seq:
                  - id: header
                    type: slices_resource_header
                types:
                  slices_resource_header:
                    seq:
                      - id: version
                        type: s4
                      - id: header
                        type:
                          switch-on: version
                          cases:
                            6: slices_resource_header_v6
                            7: slices_resource_header_v7
                            8: slices_resource_header_v7
                    types:
                      slices_resource_header_v7:
                        seq:
                          - id: descriptor_version
                            type: s4
                          - id: descriptor
                            type: descriptor_resource
                      slices_resource_header_v6:
                        seq:
                          - id: bounding_rectangle
                            type: bounding_rectangle_type
                          - id: name_of_slices_group
                            type: unicode_string_resource
                          - id: number_of_slices
                            type: s4
                          - id: slices_resource_blocks
                            type: slices_resource_block
                            #repeat: expr
                            #repeat-expr: number_of_slices
                        types:
                          bounding_rectangle_type:
                            seq:
                              - id: top
                                size: 4
                              - id: left
                                size: 4
                              - id: bottom
                                size: 4
                              - id: right
                                size: 4
                          slices_resource_block:
                            seq:
                              - id: id
                                size: 4
                              - id: group_id
                                size: 4
                              - id: origin
                                type: s4
                              - id: associated_layer_id
                                size: 4
                                if: origin == 1
                              - id: name
                                type: unicode_string_resource
                              - id: type
                                type: s4
                              - id: bounding_box
                                type: bounding_rectangle_type
                              - id: url
                                type: unicode_string_resource
                              - id: target
                                type: unicode_string_resource
                              - id: message
                                type: unicode_string_resource
                              - id: alt_tag
                                type: unicode_string_resource
                              - id: cell_text_format
                                type: u1
                                enum: cell_text_formats
                              - id: cell_text
                                type: unicode_string_resource
                              - id: horizontal_alignment
                                size: 4
                              - id: vertical_alignment
                                size: 4
                              - id: alpha_color
                                size: 1
                              - id: red
                                size: 1
                              - id: green
                                size: 1
                              - id: blue
                                size: 1
                              - id: descriptor_version
                                size: 4
                              - id: descriptor
                                type: descriptor_resource
                            enums:
                              cell_text_formats:
                                0: plain_text
                                1: html
              jump_to_xpep_resource:
                seq:
                  - id: major_version
                    type: s2
                  - id: minor_version
                    type: s2
                  - id: count
                    type: s4
                  - id: blocks
                    type: block
                    repeat: expr
                    repeat-expr: count
                types:
                  block:
                    seq:
                      - id: size
                        type: s4
                      - id: key
                        type: u4
                        enum: keys
                      - id: dirty_flag
                        type: u1
                        if: key == keys::jtdd
                      - id: mod_date
                        size: 4
                        if: key != keys::jtdd
                    enums:
                      keys:
                        0x6A744464: jtdd
              alpha_identifiers_resource:
                seq:
                  - id: number_of_alpha_identifiers
                    type: s4
                  - id: alpha_identifier
                    size: 4
                    repeat: expr
                    repeat-expr: number_of_alpha_identifiers
              url_list_resource:
                seq:
                  - id: number_of_urls
                    type: s4
                  - id: url_data
                    type: url_data_type
                    repeat: expr
                    repeat-expr: number_of_urls
                types:
                  url_data_type:
                    seq:
                      - id: long
                        size: 4
                      - id: id
                        size: 4
                      - id: string
                        type: unicode_string_resource
              version_info_resource:
                seq:
                  - id: version
                    type: s4
                  - id: has_real_merged_data
                    size: 1
                  - id: writer_name
                    type: unicode_string_resource
                  - id: reader_name
                    type: unicode_string_resource
                  - id: file_version
                    type: s4
              caption_digest_resource:
                seq:
                  - id: md5_hash
                    size: 16
              print_scale_resource:
                seq:
                  - id: style
                    type: s2
                    enum: print_scale_style
                  - id: x_location
                    size: 4
                  - id: y_location
                    size: 4
                  - id: scale
                    size: 4
                enums:
                  print_scale_style:
                    0: centered
                    1: size_to_fit
                    2: user_defined
              pixel_aspect_ratio_resource:
                seq:
                  - id: version
                    type: s4
                    doc: value should be 1 or 2
                  - id: aspect_ratio
                    type: f8
                    doc: x/y pixel aspect ratio
              alternate_duotone_colors_resource:
                seq:
                  - id: version
                    type: s2
                    doc: value should be 1
                  - id: count_1
                    type: s2
                  - id: colors
                    type: color_structure
                    repeat: expr
                    repeat-expr: count_1
                  - id: count_2
                    type: s2
                  - id: lab_colors
                    type: lab_colors_type
                    repeat: expr
                    repeat-expr: count_2
                types:
                  lab_colors_type:
                    seq:
                      - id: l
                        size: 1
                      - id: a
                        size: 1
                      - id: b
                        size: 1
              alternate_spot_colors_resource:
                seq:
                  - id: version
                    type: s2
                    doc: value should be 1
                  - id: number_of_channels
                    type: s2
                  - id: alternate_spot_colors_for_channels
                    type: alternate_spot_colors_for_channel
                    repeat: expr
                    repeat-expr: number_of_channels
                types:
                  alternate_spot_colors_for_channel:
                    seq:
                      - id: channel_id
                        size: 4
                      - id: color
                        type: color_structure
              layer_selection_ids_resource:
                seq:
                  - id: count
                    type: s2
                  - id: layer_ids
                    size: 4
                    repeat: expr
                    repeat-expr: count
              layer_groups_enabled_id_resource:
                seq:
                  - id: layer_group_enabled
                    size: 1
                    repeat: eos
              print_flags_information_resource:
                seq:
                  - id: version
                    type: s2
                    doc: value should be 1
                  - id: center_crop_marks
                    size: 1
                  - id: padding
                    contents: [0x00]
                  - id: bleed_width_value
                    size: 4
                  - id: bleed_width_scale
                    size: 2
            enums:
              image_resource_identifier:
                0x03E8: photoshop_2_0_values
                0x03E9: macintosh_print_manager_print_info_record
                0x03EA: macintosh_page_format_information
                0x03EB: indexed_color_table
                0x03ED: resolution_info
                0x03EE: alpha_channel_names
                0x03EF: obsolete_1007
                0x03F0: caption
                0x03F1: border_information
                0x03F2: background_color
                0x03F3: print_flags
                0x03F4: grayscale_multichannel_halftoning_information
                0x03F5: color_halftoning_information
                0x03F6: duotone_halftoning_information
                0x03F7: grayscale_multichannel_transfer_function
                0x03F8: color_transfer_functions
                0x03F9: duotone_transfer_functions
                0x03FA: duotone_image_information
                0x03FB: effective_black_white_values_for_dot_range
                0x03FC: obsolete_1020
                0x03FD: eps_options
                0x03FE: quick_mask_information
                0x03FF: obsolete_1023
                0x0400: layer_state_information
                0x0401: working_path
                0x0402: layers_group_information
                0x0403: obsolete_1027
                0x0404: iptc_naa_record
                0x0405: image_mode_for_raw_format_files
                0x0406: jpeg_quality
                0x0408: grid_guides_information
                0x0409: thumbnail_resource_for_photoshop_4
                0x040A: copyright_flag
                0x040B: url
                0x040C: thumbnail_resource
                0x040D: global_angle
                0x040E: color_samplers_resource
                0x040F: icc_profile
                0x0410: watermark
                0x0411: icc_untagged_profile
                0x0412: effects_visible
                0x0413: spot_halftone
                0x0414: document_specific_ids_seed_number
                0x0415: unicode_alpha_names
                0x0416: indexed_color_table_count
                0x0417: transparency_index
                0x0419: global_altitude
                0x041A: slices
                0x041B: workflow_url
                0x041C: jump_to_xpep
                0x041D: alpha_identifiers
                0x041E: url_list
                0x0421: version_info
                0x0422: exif_data_1
                0x0423: exif_data_3
                0x0424: xmp_metadata
                0x0425: caption_digest
                0x0426: print_scale
                0x0428: pixel_aspect_ratio
                0x0429: layer_comps
                0x042A: alternate_duotone_colors
                0x042B: alternate_spot_colors
                0x042D: layer_selection_ids
                0x042E: hdr_toning_information
                0x042F: print_info
                0x0430: layer_groups_enabled_id
                0x0431: color_samplers_resource
                0x0432: measurement_scale
                0x0433: timeline_information
                0x0434: sheet_disclosure
                0x0435: displayinfo_structure_for_floating_point_colors
                0x0436: onion_skins
                0x0438: count_information
                0x043A: print_information
                0x043B: print_style
                0x043C: macintosh_nsprintinfo
                0x043D: windows_devmode
                0x043E: auto_save_file_path
                0x043F: auto_save_format
                0x0440: path_selection_state
                0x07D0: path_information_saved_path_first
                #0x07D0-0x0BB6: path_information_saved_paths
                0x0BB6: path_information_saved_path_last
                0x0BB7: name_of_clipping_path
                0x0BB8: origin_path_info
                0x0FA0: plug_in_resources_first
                #0x0FA0-0x1387: plug_in_resources
                0x1387: plug_in_resources_last
                0x1B58: image_ready_variables
                0x1B59: image_ready_data_sets
                0x1B5A: image_ready_default_selected_state
                0x1B5B: image_ready_7_rollover_expanded_state
                0x1B5C: image_ready_rollover_expanded_state
                0x1B5D: image_ready_save_layer_settings
                0x1B5E: image_ready_version
                0x1F40: lightroom_workflow
                0x2710: print_flags_information
  layer_and_mask_information:
    seq:
      - id: size_of_data
        type: s4
      - id: data
        type: layer_and_mask_information_data
        size: size_of_data
    types:
      layer_and_mask_information_data:
        seq:
          - id: layer_information
            type: layer_information
          - id: global_layer_mask_information
            type: global_layer_mask_information
          - id: additional_layer_information
            type: additional_layer_information
            repeat: eos
        types:
          layer_information:
            seq:
              - id: size_of_data
                type: s4
                doc: value should be an even number (have 2 as a factor)
              - id: data
                type: layer_information_data
                size: size_of_data
            types:
              layer_information_data:
                seq:
                  - id: layer_count
                    type: s2
                  - id: layer_records
                    type: layer_record
                    repeat: expr
                    repeat-expr: layer_count
                  - id: channel_image_data_records
                    size-eos: true
                    #type: channel_image_data_record
                types:
                  layer_record:
                    seq:
                      - id: bounding_box
                        type: bounding_box_type
                      - id: number_of_channels
                        type: s2
                      - id: channel_information
                        type: channel_information_record
                        repeat: expr
                        repeat-expr: number_of_channels
                      - id: blend_mode
                        type: blend_mode_structure
                      - id: opacity
                        type: u1
                        doc: a value of 0 is transparent, value of 255 is opaque
                      - id: clipping_mode
                        type: u1
                        enum: clipping_modes
                      - id: flags
                        type: layer_record_flags
                      - id: padding
                        contents: [0x00]
                      - id: size_of_extra_data_fields
                        type: s4
                      - id: extra_data
                        type: extra_data
                        size: size_of_extra_data_fields
                    types:
                      bounding_box_type:
                        seq:
                          - id: top
                            size: 4
                          - id: left
                            size: 4
                          - id: bottom
                            size: 4
                          - id: right
                            size: 4
                      channel_information_record:
                        seq:
                          - id: id
                            type: s2
                            enum: channel_ids
                          - id: data
                            size: 4
                        enums:
                          channel_ids:
                            0: red
                            1: green
                            2: blue
                            #-1: transparency_mask
                            #-2: user_supplied_layer_mask
                            #-3: real_user_supplied_layer_mask
                      layer_record_flags:
                        seq:
                          - id: transparency_protected
                            type: b1
                          - id: visible
                            type: b1
                          - id: obsolete
                            type: b1
                          - id: bit_4_has_useful_information
                            type: b1
                          - id: pixel_data_irrelvant_to_appearance_of_document
                            type: b1
                          - id: unused_flags
                            type: b3
                      extra_data:
                        seq:
                          - id: layer_mask_data
                            type: layer_mask_adjustment_layer
                          - id: layer_blending_ranges
                            type: layer_blending_ranges
                          - id: layer_name
                            type: pascal_string_padded_to_4_byte_multiple
                          - id: additional_layer_information
                            type: additional_layer_information
                            repeat: eos
                        types:
                          layer_mask_adjustment_layer:
                            seq:
                              - id: size_of_data
                                type: s4
                              - id: data
                                type: layer_mask_adjustment_layer_data
                                size: size_of_data
                                if: size_of_data != 0
                            types:
                              layer_mask_adjustment_layer_data:
                                seq:
                                  - id: bounding_box
                                    type: bounding_box_type
                                  - id: default_color
                                    type: u1
                                    doc: value should be 0 or 255
                                  - id: flags
                                    type: flag_parameters
                                  - id: mask_parameters
                                    type: mask_parameters
                                    if: flags.user_and_or_vector_masks_have_parameters_applied == true
                                  - id: padding
                                    contents: [0x00, 0x00]
                                    if: _parent.size_of_data == 20
                                  - id: real_flags
                                    type: flag_parameters
                                    if: _parent.size_of_data != 20
                                  - id: real_user_mask_background
                                    type: u1
                                    doc: value should be 0 or 255
                                    if: _parent.size_of_data != 20
                                  - id: real_bounding_box
                                    type: bounding_box_type
                                    if: _parent.size_of_data != 20
                                types:
                                  flag_parameters:
                                    seq:
                                      - id: position_relative_to_layer
                                        type: b1
                                      - id: layer_mask_disabled
                                        type: b1
                                      - id: invert_layer_mask_when_blending
                                        type: b1
                                      - id: user_mask_came_from_rendering_other_data
                                        type: b1
                                      - id: user_and_or_vector_masks_have_parameters_applied
                                        type: b1
                                      - id: unused_flags
                                        type: b3
                                  mask_parameters:
                                    seq:
                                      - id: user_mask_density_1_byte
                                        type: b1
                                      - id: user_mask_feather_8_byte_double
                                        type: b1
                                      - id: vector_mask_density_1_byte
                                        type: b1
                                      - id: vector_mask_feather_8_byte_double
                                        type: b1
                                      - id: unused_flags
                                        type: b4
                          layer_blending_ranges:
                            seq:
                              - id: size_of_data
                                type: s4
                              - id: data
                                type: layer_blending_ranges_data
                                size: size_of_data
                            types:
                              layer_blending_ranges_data:
                                seq:
                                  - id: composite_gray_blend_range
                                    type: channel_range_data
                                  - id: channel_ranges
                                    type: channel_range_data
                                    repeat: eos
                                types:
                                  channel_range_data:
                                    seq:
                                      - id: source_range
                                        size: 4
                                      - id: destination_range
                                        size: 4
                    enums:
                      clipping_modes:
                        0: base
                        1: non_base
          global_layer_mask_information:
            seq:
              - id: size_of_data
                type: s4
              - id: data
                type: global_layer_mask_information_data
                size: size_of_data
                if: size_of_data != 0
            types:
              global_layer_mask_information_data:
                seq:
                  - id: color
                    type: color_structure
                  - id: opacity
                    type: s2
                    doc: value of 0 for transparent, value of 100 for opaque
                  - id: kind
                    type: u1
                    enum: kinds
                  - id: padding
                    size: 1
                enums:
                  kinds:
                    0: color_selected
                    1: color_protected
                    128: use_value_stored_per_layer
          additional_layer_information:
            seq:
              - id: signature
                size: 4
                doc: should be either 8BIM or 8B64
              - id: data_type
                type: u4
                enum: adjustment_layer_types
              - id: size_of_data
                type: s4
                doc: value should be an even number (have 2 as a factor)
              - id: data
                type:
                  switch-on: data_type
                  cases:
                    adjustment_layer_types::solid_color_sheet_setting: descriptor_resource_with_version
                    adjustment_layer_types::gradient_fill_setting: descriptor_resource_with_version
                    adjustment_layer_types::pattern_fill_setting: descriptor_resource_with_version
                    adjustment_layer_types::brightness_and_contrast: brightness_and_contrast_data
                    #adjustment_layer_types::levels: levels_data
                    #adjustment_layer_types::curves: curves_data
                    adjustment_layer_types::exposure: exposure_data
                    adjustment_layer_types::vibrance: descriptor_resource_with_version
                    #adjustment_layer_types::hue_saturation_for_photoshop_4: hue_saturation_for_photoshop_4_data
                    #adjustment_layer_types::hue_saturation_for_photoshop_5_and_later: hue_saturation_for_photoshop_5_and_later_data
                    #adjustment_layer_types::color_balance: color_balance_data
                    adjustment_layer_types::black_and_white: descriptor_resource_with_version
                    adjustment_layer_types::photo_filter: photo_filter_data
                    adjustment_layer_types::channel_mixer: channel_mixer_data
                    adjustment_layer_types::color_lookup: color_lookup_data
                    #adjustment_layer_types::invert: invert_data
                    #adjustment_layer_types::posterize: posterize_data
                    #adjustment_layer_types::threshold: threshold_data
                    #adjustment_layer_types::gradient_map: gradient_map_data
                    #adjustment_layer_types::selective_color: selective_color_data
                    adjustment_layer_types::effects_layer: effects_layer_data
                    adjustment_layer_types::type_tool_info: type_tool_info_data
                    adjustment_layer_types::unicode_layer_name: unicode_string_resource
                    adjustment_layer_types::layer_id: layer_id_data
  #recursion limit reached                  adjustment_layer_types::object_based_effects_layer_info: object_based_effects_layer_info_data
                    #adjustment_layer_types::patterns_1: patterns_1_data
                    #adjustment_layer_types::patterns_2: patterns_2_data
                    #adjustment_layer_types::patterns_3: patterns_3_data
                    #adjustment_layer_types::annotations: annotations_data
                    #adjustment_layer_types::blend_clipping_elements: blend_clipping_elements_data
                    #adjustment_layer_types::blend_interior_elements: blend_interior_elements_data
                    #adjustment_layer_types::knockout_setting: knockout_setting_data
                    #adjustment_layer_types::protected_setting: protected_setting_data
                    #adjustment_layer_types::sheet_color_setting: sheet_color_setting_data
                    #adjustment_layer_types::reference_point: reference_point_data
                    #adjustment_layer_types::gradient_settings: gradient_settings_data
                    #adjustment_layer_types::section_divider_setting: section_divider_setting_data
                    #adjustment_layer_types::channel_blending_restrictions_setting: channel_blending_restrictions_setting_data
                    #adjustment_layer_types::vector_mask_setting_1: vector_mask_setting_1_data
                    #adjustment_layer_types::vector_mask_setting_2: vector_mask_setting_2_data
                    #adjustment_layer_types::type_tool_object_setting: type_tool_object_setting_data
                    #adjustment_layer_types::foreign_effects_id: foreign_effects_id_data
                    #adjustment_layer_types::layer_name_source_setting: layer_name_source_setting_data
                    #adjustment_layer_types::pattern_data: pattern_data_data
                    #adjustment_layer_types::metadata_setting: metadata_setting_data
                    #adjustment_layer_types::layer_version: layer_version_data
                    #adjustment_layer_types::transparency_shapes_layer: transparency_shapes_layer_data
                    #adjustment_layer_types::layer_mask_as_global_mask: layer_mask_as_global_mask_data
                    #adjustment_layer_types::vector_mask_as_global_mask: vector_mask_as_global_mask_data
                    #adjustment_layer_types::channel_mixer: channel_mixer_data
                    #adjustment_layer_types::placed_layer: placed_layer_data
                    #adjustment_layer_types::linked_layer_1: linked_layer_1_data
                    #adjustment_layer_types::linked_layer_2: linked_layer_2_data
                    #adjustment_layer_types::linked_layer_3: linked_layer_3_data
                    adjustment_layer_types::content_generator_extra_data: descriptor_resource_with_version
                    #adjustment_layer_types::text_engine_data: text_engine_data_data
                    adjustment_layer_types::unicode_path_names: descriptor_resource_with_version
                    adjustment_layer_types::animation_effects: descriptor_resource_with_version
                    #adjustment_layer_types::filter_mask: filter_mask_data
                    #adjustment_layer_types::placed_layer_data: placed_layer_data_data
                    adjustment_layer_types::vector_stroke_data: descriptor_resource_with_version
                    #adjustment_layer_types::vector_stroke_content_data: vector_stroke_content_data_data
                    #adjustment_layer_types::using_aligned_rendering: using_aligned_rendering_data
                    #adjustment_layer_types::vector_origination_data: vector_origination_data_data
                    adjustment_layer_types::pixel_source_data_1: descriptor_resource_with_version
                    #adjustment_layer_types::pixel_source_data_2: pixel_source_data_2_data
                    adjustment_layer_types::artboard_data_1: descriptor_resource_with_version
                    adjustment_layer_types::artboard_data_2: descriptor_resource_with_version
                    adjustment_layer_types::artboard_data_3: descriptor_resource_with_version
                    #adjustment_layer_types::smart_object_layer_data: smart_object_layer_data_data
                    #adjustment_layer_types::saving_merged_transparency_1: saving_merged_transparency_1_data
                    #adjustment_layer_types::saving_merged_transparency_2: saving_merged_transparency_2_data
                    #adjustment_layer_types::saving_merged_transparency_3: saving_merged_transparency_3_data
                    #adjustment_layer_types::user_mask: user_mask_data
                    #adjustment_layer_types::filter_effects_1: filter_effects_1_data
                    #adjustment_layer_types::filter_effects_2: filter_effects_2_data
                size: size_of_data
            types:
              brightness_and_contrast_data:
                seq:
                  - id: brightness
                    size: 2
                  - id: contrast
                    size: 2
                  - id: mean_value_for_brightness_and_contrast
                    size: 2
                  - id: lab_color_only
                    size: 1
              exposure_data:
                seq:
                  - id: version
                    type: s2
                    doc: value should be 1
                  - id: exposure
                    size: 4
                  - id: offset
                    size: 4
                  - id: gamma
                    size: 4
              photo_filter_data:
                seq:
                  - id: version
                    type: s2
                    doc: value should be 2 or 3
                  - id: xyz_color
                    type: xyz_color
                    if: version == 3
                  - id: color
                    type: color_structure
                    if: version == 2
                  - id: density
                    size: 4
                  - id: preserve_luminosity
                    size: 1
                types:
                  xyz_color:
                    seq:
                      - id: x
                        size: 4
                      - id: y
                        size: 4
                      - id: z
                        size: 4
              channel_mixer_data:
                seq:
                  - id: version
                    type: s2
                    doc: value should be 1
                  - id: monochrome
                    size: 2
                  - id: color_data
                    size: 20
                    doc: >
                      vendor documentation says this 20 bytes is
                      "RGB or CMYK color plus constant for the mixer settings.
                      4 * 2 bytes of color with 2 bytes of constant"
                      but 4 * 4 != 20 and 4 * 2 + 2 != 20 so it is unclear
                      how these 20 bytes are really allocated
              color_lookup_data:
                seq:
                  - id: version
                    type: s2
                    doc: value should be 1
                  - id: descriptor_version
                    type: s4
                  - id: descriptor
                    type: descriptor_resource
              effects_layer_data:
                seq:
                  - id: version
                    type: s2
                    doc: value should be 0
                  - id: number_of_effects
                    type: s2
                    doc: value may be 6 for Photoshop v5 and v6 or 7 for Photoshop v7
                  - id: effects
                    type: effect
                    repeat: expr
                    repeat-expr: number_of_effects
                types:
                  effect:
                    seq:
                      - id: signature
                        contents: [0x38, 0x42, 0x49, 0x4D] #8BIM
                      - id: type
                        type: u4
                        enum: effect_types
                      - id: data
                        type:
                          switch-on: type
                          cases:
                            effect_types::common_state: common_state_data
                            effect_types::drop_shadow: shadow_data
                            effect_types::inner_shadow: shadow_data
                            effect_types::outer_glow: outer_glow_data
                            effect_types::inner_glow: inner_glow_data
                            effect_types::bevel: bevel_data
                            effect_types::solid_fill: solid_fill_data
                    types:
                      common_state_data:
                        seq:
                          - id: size_of_following_data
                            type: s4
                            doc: value should be 7
                          - id: version
                            type: s4
                            doc: value should be 0
                          - id: visible
                            size: 1
                            doc: value should be true
                          - id: unused
                            contents: [0x00, 0x00]
                      shadow_data:
                        seq:
                          - id: size_of_following_data
                            type: s4
                            doc: value should be 41 or 51 depending on the value of the version field
                          - id: version
                            type: s4
                            doc: value should be 0 for Photoshop v5 or 2 for Photoshop v5.5
                          - id: blur_value
                            size: 4
                            doc: unit of this value is number of pixels
                          - id: intensity
                            size: 4
                            doc: unit of this value is a percentage
                          - id: angle
                            size: 4
                            doc: unit of this value is degrees
                          - id: distance
                            size: 4
                            doc: unit of this value is number of pixels
                          - id: color
                            type: color_structure
                          - id: blend_mode
                            type: blend_mode_structure
                          - id: effect_enabled
                            size: 1
                          - id: use_this_angle_in_all_of_the_layer_effects
                            size: 1
                          - id: opacity
                            size: 1
                            doc: unit of this value is a percentage
                          - id: native_color
                            type: color_structure
                      outer_glow_data:
                        seq:
                          - id: size_of_following_data
                            type: s4
                            doc: value should be 32 for Photoshop v5 or 42 for Photoshop v5.5
                          - id: version
                            type: s4
                            doc: value should be 0 for Photoshop v5 or 2 for Photoshop v5.5
                          - id: blur_value
                            size: 4
                            doc: unit of this value is number of pixels
                          - id: intensity
                            size: 4
                            doc: unit of this value is a percentage
                          - id: color
                            type: color_structure
                          - id: blend_mode
                            type: blend_mode_structure
                          - id: effect_enabled
                            size: 1
                          - id: opacity
                            size: 1
                            doc: unit of this value is a percentage
                          - id: native_color_space
                            type: color_structure
                            if: version == 2
                      inner_glow_data:
                        seq:
                          - id: size_of_following_data
                            type: s4
                            doc: value should be 32 for Photoshop v5 or 43 for Photoshop v5.5
                          - id: version
                            type: s4
                            doc: value should be 0 for Photoshop v5 or 2 for Photoshop v5.5
                          - id: blur_value
                            size: 4
                            doc: unit of this value is number of pixels
                          - id: intensity
                            size: 4
                            doc: unit of this value is a percentage
                          - id: color
                            type: color_structure
                          - id: blend_mode
                            type: blend_mode_structure
                          - id: effect_enabled
                            size: 1
                          - id: opacity
                            size: 1
                            doc: unit of this value is a percentage
                          - id: invert
                            size: 1
                            if: version == 2
                          - id: native_color_space
                            type: color_structure
                            if: version == 2
                      bevel_data:
                        seq:
                          - id: size_of_following_data
                            type: s4
                            doc: value should be 58 for Photoshop v5 or 78 for Photoshop v5.5
                          - id: version
                            type: s4
                            doc: value should be 0 for Photoshop v5 or 2 for Photoshop v5.5
                          - id: angle
                            size: 4
                            doc: unit of this value is degrees
                          - id: strength
                            size: 4
                            doc: unit of this value is number of pixels in depth
                          - id: blur_value
                            size: 4
                            doc: unit of this value is number of pixels
                          - id: highlight_blend_mode
                            type: blend_mode_structure
                          - id: shadow_blend_mode
                            type: blend_mode_structure
                          - id: highlight_color
                            type: color_structure
                          - id: shadow_color
                            type: color_structure
                          - id: bevel_style
                            size: 1
                          - id: highlight_opacity
                            size: 1
                            doc: unit of this value is a percentage
                          - id: shadow_opacity
                            size: 1
                            doc: unit of this value is a percentage
                          - id: effect_enabled
                            size: 1
                          - id: use_this_angle_in_all_of_the_layer_effects
                            size: 1
                          - id: up_or_down
                            size: 1
                          - id: real_highlight_color
                            type: color_structure
                            if: version == 2
                          - id: real_shadow_color
                            type: color_structure
                            if: version == 2
                      solid_fill_data:
                        seq:
                          - id: size_of_following_data
                            type: s4
                            doc: value should be 34
                          - id: version
                            type: s4
                            doc: value should be 2
                          - id: key_for_blend_mode
                            type: s4
                            enum: blend_modes
                          - id: color_space
                            type: color_structure
                          - id: opacity
                            size: 1
                          - id: effect_enabled
                            size: 1
                          - id: native_color_space
                            type: color_structure
                    enums:
                      effect_types:
                        0x636D6E53: common_state #cmnS
                        0x64736477: drop_shadow #dsdw
                        0x69736477: inner_shadow #isdw
                        0x6F676C77: outer_glow #oglw
                        0x69676C77: inner_glow #iglw
                        0x6265766C: bevel #bevl
                        0x736F6669: solid_fill #sofi
              type_tool_info_data:
                seq:
                  - id: version
                    type: s2
                    doc: value should be 1
                  - id: numbers_for_transform_information
                    size: 8
                    repeat: expr
                    repeat-expr: 6
                    doc: each number has a double precision type
                  #- id: font_information
                  #  type: font_information
                  #- id: style_information
                  #  type: style_information
                  #- id: text_information
                  #  type: text_information
                  #- id: color_information
                  #  type: color_information
                types:
                  font_information:
                    seq:
                      - id: version
                        type: s2
                        doc: value should be 6
                      - id: number_of_faces
                        type: s2
                      - id: faces
                        type: face_information
                        repeat: expr
                        repeat-expr: number_of_faces
                    types:
                      face_information:
                        seq:
                          - id: mark_value
                            size: 2
                          - id: font_type_data
                            size: 4
                          - id: font_name
                            type: pascal_string_padded_to_2_byte_multiple
                          - id: font_family_name
                            type: pascal_string_padded_to_2_byte_multiple
                          - id: font_style_name
                            type: pascal_string_padded_to_2_byte_multiple
                          - id: script_value
                            size: 2
                          - id: number_of_design_axes_vector_to_follow
                            type: s4
                          - id: design_axes_vector_values
                            size: 4
                            repeat: expr
                            repeat-expr: number_of_design_axes_vector_to_follow
                  style_information:
                    seq:
                      - id: number_of_styles
                        type: s2
                      - id: styles
                        type: style_information_data
                        repeat: expr
                        repeat-expr: number_of_styles
                    types:
                      style_information_data:
                        seq:
                          - id: mark_value
                            size: 2
                          - id: face_mark_value
                            size: 2
                          - id: size_value
                            size: 4
                          - id: tracking_value
                            size: 4
                          - id: kerning_value
                            size: 4
                          - id: leading_value
                            size: 4
                          - id: base_shift_value
                            size: 4
                          - id: auto_kern_on_off
                            size: 1
                          #- id: unspecified_field_only_present_in_versions_less_than_equal_to_5
                          #  size: 1
                          #  if: _parent.version <= 5
                          - id: rotate_up_down
                            size: 1
                  text_information:
                    seq:
                      - id: type_value
                        size: 2
                      - id: scaling_factor_value
                        size: 4
                      - id: character_count_value
                        size: 4
                      - id: horizontal_placement
                        size: 4
                      - id: vertical_placement
                        size: 4
                      - id: select_start_value
                        size: 4
                      - id: select_end_value
                        size: 4
                      - id: number_of_lines
                        type: s2
                      - id: lines
                        type: text_line
                        repeat: expr
                        repeat-expr: number_of_lines
                    types:
                      text_line:
                        seq:
                          - id: character_count_value
                            size: 4
                          - id: orientation_value
                            size: 2
                          - id: alignment_value
                            size: 2
                          - id: actual_character
                            size: 2
                          - id: style_value
                            size: 2
                  color_information:
                    seq:
                      - id: color
                        type: color_structure
                      - id: anti_alias_on_off
                        size: 1
              layer_id_data:
                seq:
                  - id: layer_id
                    size: 4
              object_based_effects_layer_info_data:
                seq:
                  - id: version
                    type: s4
                    doc: value should be 0
                  - id: descriptor_version
                    type: s4
                  - id: descriptor
                    type: descriptor_resource
            enums:
              adjustment_layer_types:
                0x536F436F: solid_color_sheet_setting #SoCo
                0x4764466C: gradient_fill_setting #GdFl
                0x5074466C: pattern_fill_setting #PtFl
                0x62726974: brightness_and_contrast #brit
                0x6C65766C: levels #levl
                0x63757276: curves #curv
                0x65787041: exposure #expA
                0x76696241: vibrance #vibA
                0x68756520: hue_saturation_for_photoshop_4 #hue 
                0x68756532: hue_saturation_for_photoshop_5_and_later #hue2
                0x626C6E63: color_balance #blnc
                0x626C7768: black_and_white #blwh
                0x7068666C: photo_filter #phfl
                0x6D697872: channel_mixer #mixr
                0x636C724C: color_lookup #clrL
                0x6E767274: invert #nvrt
                0x706F7374: posterize #post
                0x74687273: threshold #thrs
                0x6772646D: gradient_map #grdm
                0x73656C63: selective_color #selc
                0x6C724658: effects_layer #lrFX
                0x74795368: type_tool_info #tySh
                0x6C756E69: unicode_layer_name #luni
                0x6C796964: layer_id #lyid
                0x6C667832: object_based_effects_layer_info #lfx2
                0x50617474: patterns_1 #Patt
                0x50617432: patterns_2 #Pat2
                0x50617433: patterns_3 #Pat3
                0x416E6E6F: annotations #Anno
                0x636C626C: blend_clipping_elements #clbl
                0x696E6678: blend_interior_elements #infx
                0x6B6E6B6F: knockout_setting #knko
                0x6C737066: protected_setting #lspf
                0x6C636C72: sheet_color_setting #lclr
                0x66787270: reference_point #fxrp
                0x6772646D: gradient_settings #grdm
                0x6C736374: section_divider_setting #lsct
                0x62727374: channel_blending_restrictions_setting #brst
                0x766D736B: vector_mask_setting_1 #vmsk
                0x76736D73: vector_mask_setting_2 #vsms
                0x54795368: type_tool_object_setting #TySh
                0x66667869: foreign_effects_id #ffxi
                0x6C6E7372: layer_name_source_setting #lnsr
                0x73687061: pattern_data #shpa
                0x73686D64: metadata_setting #shmd
                0x6C797672: layer_version #lyvr
                0x74736C79: transparency_shapes_layer #tsly
                0x6C6D676D: layer_mask_as_global_mask #lmgm
                0x766D676D: vector_mask_as_global_mask #vmgm
                0x6D697872: channel_mixer #mixr
                0x706C4C64: placed_layer #plLd
                0x6C6E6B44: linked_layer_1 #lnkD
                0x6C6E6B32: linked_layer_2 #lnk2
                0x6C6E6B33: linked_layer_3 #lnk3
                0x43674564: content_generator_extra_data #CgEd
                0x54787432: text_engine_data #Txt2
                0x70746873: unicode_path_names #pths
                0x616E4658: animation_effects #anFX
                0x464D736B: filter_mask #FMsk
                0x536F4C64: placed_layer_data #SoLd
                0x7673746B: vector_stroke_data #vstk
                0x76736367: vector_stroke_content_data #vscg
                0x736E3250: using_aligned_rendering #sn2P
                0x766F676B: vector_origination_data #vogk
                0x50785363: pixel_source_data_1 #PxSc
                0x50785344: pixel_source_data_2 #PxSD
                0x61727462: artboard_data_1 #artb
                0x61727464: artboard_data_2 #artd
                0x61626464: artboard_data_3 #abdd
                0x536F4C45: smart_object_layer_data #SoLE
                0x4D74726E: saving_merged_transparency_1 #Mtrn
                0x4D743136: saving_merged_transparency_2 #Mt16
                0x4D743332: saving_merged_transparency_3 #Mt32
                0x4C4D736B: user_mask #LMsk
                0x46586964: filter_effects_1 #FXid
                0x46456964: filter_effects_2 #FEid
  descriptor_resource_with_version:
    seq:
      - id: descriptor_version
        type: s4
      - id: descriptor
        type: descriptor_resource
  descriptor_resource:
    seq:
      - id: name_from_class_id
        type: unicode_string_resource
      - id: class_id
        type: string_or_key
      - id: number_of_items_in_descriptor
        type: s4
      - id: item
        type: descriptor_item
        repeat: expr
        repeat-expr: number_of_items_in_descriptor
        #repeat-expr: number_of_items_in_descriptor > 10 ? 10 : number_of_items_in_descriptor
    types:
      descriptor_item:
        seq:
          - id: key
            type: string_or_key
          - id: data_type
            type: u4
            enum: os_type_keys
          - id: data
            type:
              switch-on: data_type
              cases:
                os_type_keys::reference: reference_item_data
                os_type_keys::descriptor: descriptor_item_data
                os_type_keys::list: list_item_data
                os_type_keys::double: double_item_data
                os_type_keys::unit_float: unit_float_item_data
                os_type_keys::string: string_item_data
                os_type_keys::enumerated: enumerated_item_data
                os_type_keys::integer: integer_item_data
                os_type_keys::large_integer: large_integer_item_data
                os_type_keys::boolean: boolean_item_data
                os_type_keys::global_object: descriptor_item_data
                os_type_keys::class: class_item_data
                os_type_keys::global_class: class_item_data
                os_type_keys::alias: alias_item_data
                #os_type_keys::raw_data: raw_data_item_data
        types:
          reference_item_data:
            seq:
              - id: number_of_items
                type: s4
              - id: data_type
                type: u4
                enum: os_type_keys_for_type_to_use
              - id: data
                type:
                  switch-on: data_type
                  cases:
                    os_type_keys_for_type_to_use::property: reference_item_property_data
                    os_type_keys_for_type_to_use::class: reference_item_class_data
                    os_type_keys_for_type_to_use::enumerated_reference: reference_item_enumerated_reference_data
                    os_type_keys_for_type_to_use::offset: reference_item_offset_data
                    #os_type_keys_for_type_to_use::identifier: reference_item_identifier_data
                    #os_type_keys_for_type_to_use::index: reference_item_index_data
                    #os_type_keys_for_type_to_use::name: reference_item_name_data
            types:
              reference_item_property_data:
                seq:
                  - id: name_from_class_id
                    type: unicode_string_resource
                  - id: class_id
                    type: string_or_key
                  - id: key_id
                    type: string_or_key
              reference_item_class_data:
                seq:
                  - id: name_from_class_id
                    type: unicode_string_resource
                  - id: class_id
                    type: string_or_key
              reference_item_enumerated_reference_data:
                seq:
                  - id: name_from_class_id
                    type: unicode_string_resource
                  - id: class_id
                    type: string_or_key
                  - id: type_id
                    type: string_or_key
                  - id: enum
                    type: string_or_key
              reference_item_offset_data:
                seq:
                  - id: name_from_class_id
                    type: unicode_string_resource
                  - id: class_id
                    type: string_or_key
                  - id: offset
                    size: 4
            enums:
              os_type_keys_for_type_to_use:
                0x70726F70: property #prop
                0x436C7373: class #Clss
                0x456E6D72: enumerated_reference #Enmr
                0x72656C65: offset #rele
                0x49646E74: identifier #Idnt
                0x696E6478: index #indx
                0x6E616D65: name #name
          descriptor_item_data:
            seq:
              - id: descriptor
                type: descriptor_resource
          list_item_data:
            seq:
              - id: number_of_items
                type: s4
              - id: items
                type: list_item
                repeat: expr
                repeat-expr: number_of_items
            types:
              list_item:
                seq:
                  - id: item_data_type
                    type: u4
                    enum: os_type_keys
                  - id: item_data
                    type:
                      switch-on: item_data_type
                      cases:
                        os_type_keys::reference: reference_item_data
                        os_type_keys::descriptor: descriptor_item_data
                        os_type_keys::list: list_item_data
                        os_type_keys::double: double_item_data
                        os_type_keys::unit_float: unit_float_item_data
                        os_type_keys::string: string_item_data
                        os_type_keys::enumerated: enumerated_item_data
                        os_type_keys::integer: integer_item_data
                        os_type_keys::large_integer: large_integer_item_data
                        os_type_keys::boolean: boolean_item_data
                        os_type_keys::global_object: descriptor_item_data
                        os_type_keys::class: class_item_data
                        os_type_keys::global_class: class_item_data
                        os_type_keys::alias: alias_item_data
                        #os_type_keys::raw_data: raw_data_item_data
          double_item_data:
            seq:
              - id: value
                type: f8
          unit_float_item_data:
            seq:
              - id: unit
                type: s4
                enum: units
              - id: value
                type: f8
            enums:
              units:
                0x23416E67: angle_base_degrees ##Ang
                0x2352736C: density_base_per_inch ##Rsl
                0x23526C74: distance_base_72ppi ##Rlt
                0x234E6E65: none_coerced ##NNe
                0x23507263: percent_unit_value ##Prc
                0x2350786C: pixels_tagged_unit_value ##Pxl
          string_item_data:
            seq:
              - id: string
                type: unicode_string_resource
          enumerated_item_data:
            seq:
              - id: type_id
                type: string_or_key
              - id: enum
                type: string_or_key
          integer_item_data:
            seq:
              - id: value
                type: s4
          large_integer_item_data:
            seq:
              - id: value
                type: s8
          boolean_item_data:
            seq:
              - id: value
                type: b8
          class_item_data:
            seq:
              - id: name_from_class_id
                type: unicode_string_resource
              - id: class_id
                type: string_or_key
          alias_item_data:
            seq:
              - id: size_of_data
                type: s4
              - id: data
                size: size_of_data
        enums:
          os_type_keys:
            0x6F626A20: reference #obj
            0x4F626A63: descriptor #Objc
            0x566C4C73: list #VILs
            0x646F7562: double #doub
            0x556E7446: unit_float #UntF
            0x54455854: string #TEXT
            0x656E756D: enumerated #enum
            0x6C6F6E67: integer #long
            0x636F6D70: large_integer #comp
            0x626F6F6C: boolean #bool
            0x476C624F: global_object #GlbO
            0x74797065: class #type
            0x476C6243: global_class #GlbC
            0x616C6973: alias #alis
            0x74647461: raw_data #tdta
      string_or_key:
        seq:
          - id: length
            type: s4
          - id: string
            size: length
            if: length > 0
          - id: key
            size: 4
            if: length == 0
  unicode_string_resource:
    seq:
      - id: number_of_characters
        type: s4
      - id: string
        type: str
        size: number_of_characters * 2
  pascal_string_padded_to_2_byte_multiple:
    seq:
      - id: length
        type: u1
      - id: string
        size: length
      - id: padding
        size: 1
        if: length == 0 or length % 2 == 1
  pascal_string_padded_to_4_byte_multiple:
    seq:
      - id: length
        type: u1
      - id: string
        size: length
      - id: padding
        size: 4 - ((length + 1) % 4)
        if: ((length + 1) % 4) != 0
  color_structure:
    seq:
      - id: color_space
        type: s2
        enum: color_spaces
      - id: color_components
        type: u2
        repeat: expr
        repeat-expr: 4
  blend_mode_structure:
    seq:
      - id: signature
        contents: [0x38, 0x42, 0x49, 0x4D]
      - id: key
        type: u4
        enum: blend_modes
enums:
  color_mode:
    0: bitmap
    1: grayscale
    2: indexed
    3: rgb
    4: cmyk
    7: multichannel
    8: duotone
    9: lab
  color_spaces:
    0: rgb
    1: hsb
    2: cmyk
    3: pantone_matching_system
    4: focoltone_colour_system
    5: trumatch_color
    6: toyo_88_colorfinder_1050
    7: lab
    8: grayscale
    9: wide_cmyk
    10: hks_colors
    11: dic
    12: total_ink
    13: monitor_rgb
    14: duotone
    15: opacity
    16: web
    17: gray_float
    18: rgb_float
    19: opacity_float
  blend_modes:
    0x70617373: pass_through #pass
    0x6E6F726D: normal #norm
    0x64697373: dissolve #diss
    0x6461726B: darken #dark
    0x6D756C20: multiply #mul
    0x69646976: color_burn #idiv
    0x6C62726E: linear_burn #lbrn
    0x646B436C: darker_color #dkCl
    0x6C697465: lighten #lite
    0x7363726E: screen #scrn
    0x64697620: color_dodge #div
    0x6C646467: linear_dodge #lddg
    0x6C67436C: lighter_color #lgCl
    0x6F766572: overlay #over
    0x734C6974: soft_light #sLit
    0x684C6974: hard_light #hLit
    0x764C6974: vivid_light #vLit
    0x6C4C6974: linear_light #lLit
    0x704C6974: pin_light #pLit
    0x684D6978: hard_mix #hMix
    0x64696666: difference #diff
    0x736D7564: exclusion #smud
    0x66737562: subtract #fsub
    0x66646976: divide #fdiv
    0x68756520: hue #hue
    0x73617420: saturation #sat
    0x636F6C72: color #colr
    0x6C756D20: luminosity #lum
