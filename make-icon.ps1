Add-Type -AssemblyName System.Drawing

function New-MmcIcon {
  param([int]$size, [string]$path, [bool]$withText = $true)

  $bmp = New-Object System.Drawing.Bitmap($size, $size)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
  $g.Clear([System.Drawing.Color]::Transparent)

  # 紫粉对角渐变圆（用反射精确选构造函数，避开 PS 重载歧义）
  $c1 = [System.Drawing.Color]::FromArgb(139, 92, 246)   # 8b5cf6
  $c2 = [System.Drawing.Color]::FromArgb(226, 72, 198)    # e248c6
  $pt1 = New-Object System.Drawing.Point(0, 0)
  $pt2 = New-Object System.Drawing.Point($size, $size)
  $ctorTypes = [Type[]]@([System.Drawing.Point], [System.Drawing.Point], [System.Drawing.Color], [System.Drawing.Color])
  $ctor = [System.Drawing.Drawing2D.LinearGradientBrush].GetConstructor($ctorTypes)
  $brush = $ctor.Invoke(@($pt1, $pt2, $c1, $c2))
  $g.FillEllipse($brush, 0, 0, ($size - 1), ($size - 1))

  $s = $size / 100.0

  # 白色 M
  $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::White, ($size * 0.095))
  $pen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
  $pen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
  $pen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
  $pts = @(
    (New-Object System.Drawing.PointF((28 * $s), (58 * $s))),
    (New-Object System.Drawing.PointF((28 * $s), (33 * $s))),
    (New-Object System.Drawing.PointF((50 * $s), (51 * $s))),
    (New-Object System.Drawing.PointF((72 * $s), (33 * $s))),
    (New-Object System.Drawing.PointF((72 * $s), (58 * $s)))
  )
  $g.DrawLines($pen, $pts)

  # MMC 文字
  if ($withText) {
    $font = New-Object System.Drawing.Font('Arial', ($size * 0.135), [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
    $wbrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g.DrawString('MMC', $font, $wbrush, (New-Object System.Drawing.PointF(($size / 2.0), ($size * 0.785))), $sf)
  }

  $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose(); $bmp.Dispose()
  Write-Host "saved $path"
}

$dir = 'c:\Users\H\Documents\trae_projects\mmc-dapp'
New-MmcIcon 512 "$dir\logo-512.png" $true
New-MmcIcon 180 "$dir\apple-touch-icon.png" $true
New-MmcIcon 32  "$dir\favicon-32.png" $false
