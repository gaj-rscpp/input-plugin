package com.appgyver.plugins.nativeinput;

import com.pixate.freestyle.annotations.PXDocElement;
import com.pixate.freestyle.annotations.PXDocProperty;
import com.pixate.freestyle.cg.paints.PXPaint;
import com.pixate.freestyle.cg.paints.PXSolidPaint;
import com.pixate.freestyle.styling.PXDeclaration;
import com.pixate.freestyle.styling.PXRuleSet;
import com.pixate.freestyle.styling.adapters.PXTextViewStyleAdapter;
import com.pixate.freestyle.styling.infos.PXLineBreakInfo;
import com.pixate.freestyle.styling.stylers.PXColorStyler;
import com.pixate.freestyle.styling.stylers.PXFillStyler;
import com.pixate.freestyle.styling.stylers.PXFontStyler;
import com.pixate.freestyle.styling.stylers.PXGenericStyler;
import com.pixate.freestyle.styling.stylers.PXStyler;
import com.pixate.freestyle.styling.stylers.PXStylerBase;
import com.pixate.freestyle.styling.stylers.PXStylerContext;
import com.pixate.freestyle.styling.stylers.PXTextContentStyler;

import android.graphics.Typeface;
import android.text.TextUtils;
import android.widget.EditText;
import android.widget.TextView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * EditText Pixate Style Adapter
 */
@PXDocElement(properties = {
        @PXDocProperty(name = "text-transform", syntax = "uppercase | lowercase"),
        @PXDocProperty(name = "text-overflow", syntax = "word-wrap | character-wrap | ellipsis-head | ellipsis-tail | ellipsis-middle"),
        @PXDocProperty(name = "compound-padding", syntax = "<length>")})
public class CustomEditTextAdapter extends PXTextViewStyleAdapter {

    static final String TAG = "EditTextWithBorderStyleAdapter";

    public CustomEditTextAdapter() {

    }

    @Override
    public String getElementName(Object object) {
        return "native-input";
    }

    /*
     * (non-Javadoc)
     * @see
     * com.pixate.freestyle.styling.adapters.PXViewStyleAdapter#createStylers()
     */
    @Override
    protected List<PXStyler> createStylers() {
        List<PXStyler> stylers = super.createStylers();

        stylers.add(new PXFontStyler(new PXStylerBase.PXStylerInvocation() {
            public void invoke(Object view, PXStyler styler, PXStylerContext context) {
                EditText textView = (EditText) view;
                Typeface typeface = context.getFont();
                if (typeface != null) {
                    textView.setTypeface(typeface);
                }
                textView.setTextSize(context.getFontSize());
            }
        }));

        stylers.add(new PXFillStyler(new PXStylerBase.PXStylerInvocation() {
            @Override
            public void invoke(Object view, PXStyler styler, PXStylerContext context) {
                CustomEditText editText = (CustomEditText) view;
                PXPaint paint = context.getFill();
                if(paint instanceof PXSolidPaint){
                    PXSolidPaint solidPaint = (PXSolidPaint)paint;
                    editText.setBackgroundColor(solidPaint.getColor());
                }
            }
        }));

        stylers.add(new PXColorStyler(new PXStylerBase.PXStylerInvocation() {
            public void invoke(Object view, PXStyler styler, PXStylerContext context) {
                EditText editText = (EditText) view;
                int color = context.getColor();
                editText.setTextColor(color);
            }
        }));

        stylers.add(new PXTextContentStyler(new PXStylerBase.PXStylerInvocation() {
            public void invoke(Object view, PXStyler styler, PXStylerContext context) {
                EditText textView = (EditText) view;
                textView.setText(context.getText());
            }
        }));

        Map<String, PXStylerBase.PXDeclarationHandler>
                handlers = new HashMap<String, PXStylerBase.PXDeclarationHandler>();
        handlers.put("text-transform", new PXStylerBase.PXDeclarationHandler() {
            public void process(PXDeclaration declaration, PXStylerContext stylerContext) {
                TextView textView = (TextView) stylerContext.getStyleable();
                String newTitle = declaration.transformString((String) textView.getText()
                                                                               .toString());
                textView.setText(newTitle);
            }
        });

        handlers.put("text-overflow", new PXStylerBase.PXDeclarationHandler() {
            public void process(PXDeclaration declaration, PXStylerContext stylerContext) {
                TextView textView = (TextView) stylerContext.getStyleable();
                PXLineBreakInfo.PXLineBreakMode lineBreakMode = declaration.getLineBreakModeValue();
                TextUtils.TruncateAt androidValue = lineBreakMode.getAndroidValue();
                boolean changed = false;

                if (androidValue != null) {
                    textView.setEllipsize(androidValue);
                    changed = true;
                } else {
                    switch (lineBreakMode) {
                        case CLIP:
                            textView.setSingleLine();
                            changed = true;
                            break;
                        default:
                            // TODO can other values be set to
                            // transformation methods?
                            break;
                    }
                }

                if (!changed) {
                    // Set to defaults
                    textView.setSingleLine(false);
                }
            }
        });

        handlers.put("compound-padding", new PXStylerBase.PXDeclarationHandler() {
            public void process(PXDeclaration declaration, PXStylerContext stylerContext) {
                TextView styleable = (TextView) stylerContext.getStyleable();
                int padding = (int) declaration.getFloatValue(stylerContext.getDisplayMetrics());
                if (styleable.getCompoundDrawablePadding() != padding) {
                    styleable.setCompoundDrawablePadding(padding);
                }
            }
        });

        stylers.add(new PXGenericStyler(handlers));
        return stylers;
    }

    @Override
    public boolean updateStyle(List<PXRuleSet> ruleSets, List<PXStylerContext> contexts) {
        if (!super.updateStyle(ruleSets, contexts)) {
            return false;
        }
        return true;
    }
}
