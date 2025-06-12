WickedPdf.config = {
  # Let wkhtmltopdf-binary gem handle the path automatically
  # exe_path: '/usr/local/bin/wkhtmltopdf',
  
  # Global PDF options
  page_size: 'A4',
  
  # Default margins
  margin: {
    top: 15,
    bottom: 15,
    left: 10,
    right: 10
  },
  
  # Encoding
  encoding: 'UTF-8',
  
  # Print media type
  print_media_type: true,
  
  # Disable smart shrinking
  disable_smart_shrinking: true,
  
  # Use X server for running wkhtmltopdf
  use_xvfb: false,
  
  # Quiet mode
  quiet: true
} 