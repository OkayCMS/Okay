{if !$width}{assign var="width" value="40"}{/if}
{if !$height}{assign var="height" value="40"}{/if}
{if !$fill}{assign var="fill" value="#000000"}{/if}

{if $svgId == "search_icon"}
<svg class="search_icon" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="26" height="28" viewBox="0 0 26 28">
    <path fill="currentColor" d="M18 13c0-3.859-3.141-7-7-7s-7 3.141-7 7 3.141 7 7 7 7-3.141 7-7zM26 26c0 1.094-0.906 2-2 2-0.531 0-1.047-0.219-1.406-0.594l-5.359-5.344c-1.828 1.266-4.016 1.937-6.234 1.937-6.078 0-11-4.922-11-11s4.922-11 11-11 11 4.922 11 11c0 2.219-0.672 4.406-1.937 6.234l5.359 5.359c0.359 0.359 0.578 0.875 0.578 1.406z"></path>
</svg>
{/if}

{if $svgId == "remove_icon"}
<svg class="remove_icon" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="20" height="20" viewBox="0 0 20 20">
    <path fill="currentColor" d="M15.833 5.346l-1.179-1.179-4.654 4.654-4.654-4.654-1.179 1.179 4.654 4.654-4.654 4.654 1.179 1.179 4.654-4.654 4.654 4.654 1.179-1.179-4.654-4.654z"></path>
</svg>
{/if}

{if $svgId == "success_icon"}
<svg viewBox="0 0 32.296 32.296" width="28px" height="28px">
    <path d="M31.923,9.14L13.417,27.642c-0.496,0.494-1.299,0.494-1.793,0L0.37,16.316   c-0.494-0.496-0.494-1.302,0-1.795l2.689-2.687c0.496-0.495,1.299-0.495,1.793,0l7.678,7.729L27.438,4.654   c0.494-0.494,1.297-0.494,1.795,0l2.689,2.691C32.421,7.84,32.421,8.646,31.923,9.14z" fill="currentColor"/>
</svg>

{/if}

{if $svgId == "arrow_right"}
<svg class="arrow_right" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="24" height="24" viewBox="0 0 24 24">
    <path fill="currentColor" d="M16.462 12l-9.805-10.188c-0.368-0.371-0.368-0.971 0-1.344 0.368-0.371 0.962-0.371 1.33 0l10.751 10.858c0.368 0.372 0.368 0.973 0 1.344l-10.751 10.858c-0.368 0.372-0.962 0.371-1.33 0-0.368-0.369-0.368-0.971 0-1.344l9.805-10.184z"></path>
</svg>
{/if}

{if $svgId == "menu_icon"}
    <svg class="menu_icon" width="16px" height="12px" viewBox="0 0 16 12"  version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
        <g>
            <rect fill="currentColor" class="bar" x="1" y="10" width="16" height="2"></rect>
            <rect fill="currentColor" class="bar" x="1" y="5" width="16" height="2"></rect>
            <rect fill="currentColor" class="bar" x="1" y="0" width="16" height="2"></rect>
        </g>
    </svg>
{/if}





