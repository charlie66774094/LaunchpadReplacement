// 平滑滚动功能
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        document.querySelector(this.getAttribute('href')).scrollIntoView({
            behavior: 'smooth'
        });
    });
});

// 下载按钮点击跟踪
document.querySelectorAll('.download-button').forEach(button => {
    button.addEventListener('click', function() {
        console.log('用户点击了下载按钮');
        // 这里可以添加下载跟踪代码
    });
});

// GitHub按钮点击跟踪
document.querySelectorAll('.github-button').forEach(button => {
    button.addEventListener('click', function() {
        console.log('用户点击了GitHub按钮');
        // 这里可以添加GitHub访问跟踪代码
    });
});

// 页面加载完成后的初始化
document.addEventListener('DOMContentLoaded', function() {
    console.log('LaunchpadReplacement 网站已加载');
});

