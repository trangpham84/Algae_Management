/**
 * Toast Notification System for AlgaeDB
 */
(function () {
    // Create toast container if not exists
    let container = document.getElementById('toast-container');
    if (!container) {
        container = document.createElement('div');
        container.id = 'toast-container';
        container.className = 'toast-container';
        document.body.appendChild(container);
    }

    /**
     * Show a toast notification.
     * @param {string} message - The message text
     * @param {string} type - 'success', 'error', or 'info'
     * @param {number} duration - Duration in ms (default: 3000)
     */
    window.showToast = function (message, type, duration) {
        type = type || 'info';
        duration = duration || 3000;

        const toast = document.createElement('div');
        toast.className = 'toast toast-' + type;

        // Icon
        let icon = '';
        if (type === 'success') icon = '&#10003;';
        else if (type === 'error') icon = '&#10007;';
        else icon = '&#8505;';

        toast.innerHTML = '<span style="font-size:1.1em">' + icon + '</span> ' + message;
        container.appendChild(toast);

        // Auto remove
        setTimeout(function () {
            toast.style.animation = 'fade-out 0.3s ease-out forwards';
            setTimeout(function () {
                if (toast.parentNode) toast.parentNode.removeChild(toast);
            }, 300);
        }, duration);
    };

    /**
     * DNA Sequence Renderer — colors A/T/G/C nucleotides
     */
    window.renderDnaSequence = function (sequence, maxLen) {
        if (!sequence) return '';
        var display = maxLen && sequence.length > maxLen
            ? sequence.substring(0, maxLen) + '\u2026'
            : sequence;

        var html = '<span class="dna-sequence">';
        for (var i = 0; i < display.length; i++) {
            var c = display.charAt(i).toUpperCase();
            if ('ATGC'.indexOf(c) >= 0) {
                html += '<span class="nt-' + c + '">' + display.charAt(i) + '</span>';
            } else {
                html += display.charAt(i);
            }
        }
        html += '</span>';
        return html;
    };
})();
